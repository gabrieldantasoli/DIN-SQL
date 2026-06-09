"""
llm_client.py — Cliente para um servidor vLLM (API OpenAI-compatible).

Substitui as chamadas `openai==0.27` (`openai.ChatCompletion.create`) do
DIN-SQL original pelo SDK `openai>=1.0`, apontando para um endpoint local do
vLLM. Mantém a mesma semântica usada no paper (temperature, max_tokens, stop)
e adiciona reespera/retentativa — equivalente ao `while ... try/except sleep(3)`
do código original, porém encapsulado.

Uso típico:
    from llm_client import LLMClient
    llm = LLMClient(base_url="http://localhost:8000/v1")  # auto-detecta o modelo
    texto = llm.generate(prompt, temperature=0.0, max_tokens=600, stop=["Q:"])

Variáveis de ambiente reconhecidas:
    VLLM_BASE_URL  (default http://localhost:8000/v1)
    VLLM_MODEL     (default: auto-detecta via /models)
    VLLM_API_KEY   (default "EMPTY" — o vLLM não exige chave por padrão)
"""

from __future__ import annotations

import os
import time
from typing import List, Optional

from openai import OpenAI


class LLMClient:
    def __init__(
        self,
        model: Optional[str] = None,
        base_url: Optional[str] = None,
        api_key: Optional[str] = None,
        endpoint: str = "chat",           # "chat" (/v1/chat/completions) ou "completion"
        max_retries: int = 5,
        retry_wait: float = 3.0,
        timeout: float = 180.0,
        seed: Optional[int] = None,       # seed de amostragem (robustez reproduzível)
    ):
        self.base_url = base_url or os.getenv("VLLM_BASE_URL", "http://localhost:8000/v1")
        self.api_key = api_key or os.getenv("VLLM_API_KEY", "EMPTY")
        self.endpoint = endpoint
        self.max_retries = max_retries
        self.retry_wait = retry_wait
        self.seed = seed
        self.client = OpenAI(base_url=self.base_url, api_key=self.api_key, timeout=timeout)

        self.model = model or os.getenv("VLLM_MODEL", "") or self._autodetect_model()
        if not self.model:
            raise RuntimeError(
                f"Não foi possível detectar o modelo em {self.base_url}. "
                f"O servidor vLLM está no ar? Passe --model ou defina VLLM_MODEL."
            )

    # ------------------------------------------------------------------ #
    def _autodetect_model(self) -> str:
        """Pega o primeiro modelo servido pelo endpoint /models."""
        try:
            models = self.client.models.list()
            if models.data:
                return models.data[0].id
        except Exception:
            pass
        return ""

    # ------------------------------------------------------------------ #
    def generate(
        self,
        prompt: str,
        temperature: float = 0.0,
        max_tokens: int = 600,
        stop: Optional[List[str]] = None,
        top_p: float = 1.0,
        n: int = 1,
    ) -> str:
        """Gera texto a partir do prompt, com retentativa. Retorna a string da
        primeira escolha (equivale a `response['choices'][0]...` do código antigo)."""
        last_err = None
        for attempt in range(1, self.max_retries + 1):
            try:
                if self.endpoint == "chat":
                    resp = self.client.chat.completions.create(
                        model=self.model,
                        messages=[{"role": "user", "content": prompt}],
                        temperature=temperature,
                        max_tokens=max_tokens,
                        top_p=top_p,
                        n=n,
                        stop=stop,
                        seed=self.seed,
                        stream=False,
                    )
                    content = resp.choices[0].message.content
                else:  # completion
                    resp = self.client.completions.create(
                        model=self.model,
                        prompt=prompt,
                        temperature=temperature,
                        max_tokens=max_tokens,
                        top_p=top_p,
                        n=n,
                        stop=stop,
                        seed=self.seed,
                        stream=False,
                    )
                    content = resp.choices[0].text
                return content if content is not None else ""
            except Exception as e:  # rede, timeout, sobrecarga do servidor, etc.
                last_err = e
                if attempt < self.max_retries:
                    time.sleep(self.retry_wait)
        raise RuntimeError(
            f"Chamada ao LLM falhou após {self.max_retries} tentativas: {last_err}"
        )


# --------------------------------------------------------------------------- #
# Auto-teste: `python src/llm_client.py` faz um ping no servidor vLLM.
if __name__ == "__main__":
    import sys

    base = sys.argv[1] if len(sys.argv) > 1 else None
    try:
        llm = LLMClient(base_url=base)
    except Exception as e:
        print(f"[ERRO] {e}")
        sys.exit(1)
    print(f"Modelo detectado: {llm.model}")
    out = llm.generate(
        'Translate to SQL: "How many singers are there?" Schema: singer(id, name). '
        "Return only SQL.",
        max_tokens=64,
        stop=["Q:"],
    )
    print("Resposta do modelo:\n" + out)
