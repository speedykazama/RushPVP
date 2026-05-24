import React, { useEffect, useState } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
import type { DominationPromptPayload } from "../types/nui";

function cooldownLine(ends: number | null, now: number): string {
  if (ends == null || ends <= 0) {
    return "Sem cooldown ativo — área disponível.";
  }
  const ms = ends > 1e12 ? ends : ends * 1000;
  if (Number.isNaN(ms)) return "Cooldown registrado — verifique o painel.";
  if (now >= ms) return "Cooldown encerrado — área disponível.";
  const diff = ms - now;
  const s = Math.floor(diff / 1000);
  const h = Math.floor(s / 3600);
  const m = Math.floor((s % 3600) / 60);
  if (h > 72) {
    return `Cooldown até ${new Date(ms).toLocaleString("pt-BR")}`;
  }
  if (h > 0) return `Cooldown ativo — faltam ${h}h ${m}m`;
  if (m > 0) return `Cooldown ativo — faltam ${m} min`;
  return `Cooldown ativo — faltam ${s}s`;
}

export const DominationPrompt: React.FC = () => {
  const [state, setState] = useState<DominationPromptPayload>({
    visible: false,
  });
  const [now, setNow] = useState(() => Date.now());

  useNuiEvent<DominationPromptPayload>("setDominationPrompt", setState);

  useEffect(() => {
    if (!state.visible || state.domination_active === true) return;
    const t = window.setInterval(() => setNow(Date.now()), 1000);
    return () => window.clearInterval(t);
  }, [state.visible, state.domination_active]);

  if (!state.visible) return null;

  /* Durante disputa só a HUD lateral importa — o card inferior some. */
  if (state.domination_active === true) return null;

  const ownerDisplay =
    (state.owner_label && state.owner_label.trim() !== ""
      ? state.owner_label
      : null) ||
    (state.owner_group && state.owner_group.trim() !== ""
      ? state.owner_group
      : null);

  return (
    <div className="vd-dom-prompt" role="status" aria-live="polite">
      <div className="vd-dom-prompt-inner shadcn-card-elevated">
        <div className="vd-dom-prompt-head">
          {state.image_url ? (
            <img
              className="vd-dom-prompt-thumb"
              src={state.image_url}
              alt=""
            />
          ) : null}
          <div>
            <p className="vd-dom-prompt-kicker">Dominação</p>
            <p className="vd-dom-prompt-title">{state.name}</p>
          </div>
        </div>
        <dl className="vd-dom-prompt-dl">
          <div>
            <dt>Cooldown</dt>
            <dd>{cooldownLine(state.cooldown_ends, now)}</dd>
          </div>
          <div>
            <dt>Dono (grupo)</dt>
            <dd>{ownerDisplay ?? "Nenhum grupo"}</dd>
          </div>
        </dl>
        <p className="vd-dom-prompt-hint">
          Pressione <kbd className="vd-dom-prompt-kbd">E</kbd> para iniciar a
          dominação desta área.
        </p>
      </div>
    </div>
  );
};
