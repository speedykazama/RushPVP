import React from "react";

export const AdminSectionLogs: React.FC = () => {
  return (
    <section className="vd-admin-panel" aria-labelledby="vd-logs-head">
      <h2 id="vd-logs-head" className="vd-admin-panel-title">
        Logs de dominação
      </h2>
      <p className="vd-admin-panel-text">
        Aqui entrará a lista estilo &quot;Grupo X dominou o local Y às
        10h00&quot;, paginada e filtrável. Backend e eventos serão plugados na
        próxima etapa.
      </p>
      <div className="vd-admin-empty-state" role="status">
        Nenhum evento carregado — aguardando integração.
      </div>
    </section>
  );
};
