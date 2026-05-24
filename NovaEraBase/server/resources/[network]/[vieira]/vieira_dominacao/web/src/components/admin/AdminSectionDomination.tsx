import React, { useCallback, useEffect, useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { fetchNui } from "../../utils/fetchNui";
import { useVisibility } from "../../providers/VisibilityProvider";
import type { DominationWizardPayload, TerritoryRow } from "../../types/nui";
import { DominationWizard } from "./DominationWizard";

function formatCooldownEnd(ts: number | null): string {
  if (ts == null || ts <= 0) return "Sem cooldown";
  const ms = ts > 1e12 ? ts : ts * 1000;
  const d = new Date(ms);
  if (Number.isNaN(d.getTime())) return "Cooldown ativo";
  return `Até ${d.toLocaleString("pt-BR")}`;
}

export const AdminSectionDomination: React.FC = () => {
  const { openTerritoryDetail } = useVisibility();
  const [rows, setRows] = useState<TerritoryRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [wizard, setWizard] = useState<DominationWizardPayload | null>(null);

  const load = useCallback(() => {
    setLoading(true);
    fetchNui<TerritoryRow[]>("getTerritories", undefined, [])
      .then((r) => setRows(Array.isArray(r) ? r : []))
      .catch(() => setRows([]))
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  useNuiEvent("territoryDeleted", () => {
    load();
  });

  useNuiEvent<DominationWizardPayload>("openDominationWizard", (data) => {
    if (data?.points && data.points.length >= 3) setWizard(data);
  });

  useNuiEvent("closeDominationWizard", () => setWizard(null));

  const startCreate = () => {
    fetchNui("createDominationStart").catch(() => undefined);
  };

  return (
    <section className="vd-dom-page" aria-labelledby="vd-dom-head">
      <div className="vd-dom-toolbar">
        <h2 id="vd-dom-head" className="vd-admin-panel-title">
          Territórios
        </h2>
        <button type="button" className="vd-btn vd-btn-primary" onClick={startCreate}>
          Nova dominação
        </button>
      </div>
      <p className="vd-admin-panel-text">
        Clique em um card para abrir a aba <strong>Território</strong> com teleporte,
        edição de poly, nome, URL, dono, cooldown e exclusão. Nova dominação abre o
        fluxo de poly no mundo e depois o formulário de nome/URL.
      </p>

      {loading ? (
        <p className="vd-admin-panel-text">Carregando…</p>
      ) : rows.length === 0 ? (
        <div className="vd-admin-empty-state" role="status">
          Nenhum território cadastrado. Clique em &quot;Nova dominação&quot; para
          criar o primeiro.
        </div>
      ) : (
        <div className="vd-territory-grid">
          {rows.map((t) => (
            <button
              key={t.id}
              type="button"
              className="vd-territory-card vd-territory-card-btn"
              onClick={() => openTerritoryDetail(t.id)}
            >
              <div className="vd-territory-card-head">
                {t.image_url ? (
                  <img
                    className="vd-territory-thumb"
                    src={t.image_url}
                    alt=""
                    loading="lazy"
                    onError={(e) => {
                      (e.target as HTMLImageElement).style.display = "none";
                    }}
                  />
                ) : (
                  <div className="vd-territory-thumb vd-territory-thumb-ph" />
                )}
                <div>
                  <h3 className="vd-territory-name">{t.name}</h3>
                  <p className="vd-territory-meta">#{t.id}</p>
                </div>
              </div>
              <dl className="vd-territory-dl">
                <div>
                  <dt>Dominando</dt>
                  <dd>
                    {(t.owner_label && t.owner_label.trim()) ||
                      t.owner_group ||
                      "—"}
                  </dd>
                </div>
                <div>
                  <dt>Cooldown</dt>
                  <dd>{formatCooldownEnd(t.cooldown_ends)}</dd>
                </div>
                <div>
                  <dt>Vértices</dt>
                  <dd>{t.point_count}</dd>
                </div>
              </dl>
            </button>
          ))}
        </div>
      )}

      {wizard && (
        <DominationWizard
          draft={wizard}
          onClose={() => {
            setWizard(null);
            load();
          }}
        />
      )}
    </section>
  );
};
