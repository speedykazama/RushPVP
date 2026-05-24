import React, { useEffect, useState } from "react";
import { fetchNui } from "../../utils/fetchNui";
import type { DominationPoint, DominationWizardPayload } from "../../types/nui";

interface Props {
  draft: DominationWizardPayload;
  onClose: () => void;
}

function centroidXY(pts: DominationPoint[]) {
  if (pts.length === 0) return { x: 0, y: 0 };
  let sx = 0;
  let sy = 0;
  for (const p of pts) {
    sx += p.x;
    sy += p.y;
  }
  const n = pts.length;
  return { x: sx / n, y: sy / n };
}

export const DominationWizard: React.FC<Props> = ({ draft, onClose }) => {
  const [name, setName] = useState("");
  const [imageUrl, setImageUrl] = useState("");
  const [saving, setSaving] = useState(false);
  const [err, setErr] = useState<string | null>(null);

  const c = centroidXY(draft.points);
  const zMid = (draft.minZ + draft.maxZ) / 2;

  useEffect(() => {
    const onEsc = (e: KeyboardEvent) => {
      if (e.code !== "Escape") return;
      onClose();
    };
    window.addEventListener("keydown", onEsc);
    return () => window.removeEventListener("keydown", onEsc);
  }, [onClose]);

  useEffect(() => {
    window.dispatchEvent(
      new MessageEvent("message", {
        data: { action: "setEscapeBlock", data: { block: true } },
      }),
    );
    return () => {
      window.dispatchEvent(
        new MessageEvent("message", {
          data: { action: "setEscapeBlock", data: { block: false } },
        }),
      );
    };
  }, []);

  const submit = () => {
    setErr(null);
    setSaving(true);
    fetchNui<{ ok: boolean; error?: string }>("saveTerritory", {
      name: name.trim(),
      image_url: imageUrl.trim(),
      min_z: draft.minZ,
      max_z: draft.maxZ,
      points: draft.points,
    })
      .then((r) => {
        if (r?.ok) onClose();
        else setErr(r?.error || "Não foi possível salvar.");
      })
      .catch(() => setErr("Erro de comunicação com o client."))
      .finally(() => setSaving(false));
  };

  return (
    <div
      className="vd-wizard-root"
      role="dialog"
      aria-modal="true"
      aria-labelledby="vd-wizard-title"
      onKeyDown={(e) => {
        if (e.key === "Escape") e.stopPropagation();
      }}
    >
      <div className="vd-wizard-backdrop" aria-hidden />
      <div className="vd-wizard-card shadcn-card-elevated">
        <h2 id="vd-wizard-title" className="vd-wizard-title">
          Finalizar dominação
        </h2>
        <p className="vd-wizard-sub">
          {draft.points.length} vértices · centro automático (
          {c.x.toFixed(1)}, {c.y.toFixed(1)}, {zMid.toFixed(1)})
        </p>

        <label className="vd-wizard-label" htmlFor="vd-wiz-name">
          Nome da dominação
        </label>
        <input
          id="vd-wiz-name"
          className="vd-wizard-input shadcn-input"
          value={name}
          onChange={(e) => setName(e.target.value)}
          maxLength={128}
          placeholder="Ex.: Porto de Los Santos"
          autoComplete="off"
        />

        <label className="vd-wizard-label" htmlFor="vd-wiz-url">
          URL (imagem / banner)
        </label>
        <input
          id="vd-wiz-url"
          className="vd-wizard-input shadcn-input"
          value={imageUrl}
          onChange={(e) => setImageUrl(e.target.value)}
          maxLength={512}
          placeholder="https://..."
          autoComplete="off"
        />

        {err && <p className="vd-wizard-err">{err}</p>}

        <div className="vd-wizard-actions">
          <button
            type="button"
            className="vd-btn vd-btn-outline"
            disabled={saving}
            onClick={onClose}
          >
            Cancelar
          </button>
          <button
            type="button"
            className="vd-btn vd-btn-primary"
            disabled={saving || !name.trim()}
            onClick={submit}
          >
            {saving ? "Salvando…" : "Salvar"}
          </button>
        </div>
      </div>
    </div>
  );
};
