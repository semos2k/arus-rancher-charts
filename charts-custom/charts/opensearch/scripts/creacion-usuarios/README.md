Admin       all
sopseg      tableros, visualizaciones, descubrimiento, creación de indices 
cliente     solo visualización de datos
seguridad solo lectura logs y auditoria

------------

	
arusadmin: 1234567
soporte: 1234567
seguridad: 1234567
cliente: 1234567

------------

PUT _plugins/_security/api/roles/arus_soporte
{
    "cluster_permissions" : [
      "cluster_composite_ops"
    ],
    "index_permissions" : [
      {
        "index_patterns" : [
          ".kibana",
          ".kibana-6",
          ".kibana_*",
          ".opensearch_dashboards",
          ".opensearch_dashboards-6",
          ".opensearch_dashboards_*"
        ],
        "fls" : [ ],
        "masked_fields" : [ ],
        "allowed_actions" : [
          "read",
          "delete",
          "manage",
          "index"
        ]
      },
      {
        "index_patterns" : [
          ".tasks",
          ".management-beats",
          "*:.tasks",
          "*:.management-beats"
        ],
        "fls" : [ ],
        "masked_fields" : [ ],
        "allowed_actions" : [
          "indices_all"
        ]
      },
      {
        "index_patterns" : [
          "auditoria-*",
          "sso-logs-*",
          "fluentbit-*"
        ],
        "dls" : "",
        "fls" : [ ],
        "masked_fields" : [ ],
        "allowed_actions" : [
          "read",
          "index"
        ]
      }
    ],
    "tenant_permissions" : [
      {
        "tenant_patterns" : [
          "global_tenant"
        ],
        "allowed_actions" : [
          "kibana_all_write"
        ]
      }
    ]
}

PUT _plugins/_security/api/rolesmapping/arus_soporte
{
  "backend_roles" : [ "arussoporte" ]
}

-----------

PUT _plugins/_security/api/roles/arus_seguridad
{
    "cluster_permissions" : [
      "cluster_composite_ops"
    ],
    "index_permissions" : [
      {
        "index_patterns" : [
          ".kibana",
          ".kibana-6",
          ".kibana_*",
          ".opensearch_dashboards",
          ".opensearch_dashboards-6",
          ".opensearch_dashboards_*"
        ],
        "fls" : [ ],
        "masked_fields" : [ ],
        "allowed_actions" : [
          "read",
          "index"
        ]
      },
      {
        "index_patterns" : [
          "auditoria-*",
          "sso-logs-*",
          "fluentbit-*"
        ],
        "dls" : "",
        "fls" : [ ],
        "masked_fields" : [ ],
        "allowed_actions" : [
          "read",
          "index"
        ]
      }
    ],
    "tenant_permissions" : [
      {
        "tenant_patterns" : [
          "global_tenant"
        ],
        "allowed_actions" : [
          "kibana_all_read"
        ]
      }
    ]
}

PUT _plugins/_security/api/rolesmapping/arus_seguridad
{
  "backend_roles" : [ "arusseguridad" ]
}

-----------

PUT _plugins/_security/api/roles/arus_cliente
{
    "cluster_permissions" : [
      "cluster_composite_ops"
    ],
    "index_permissions" : [
      {
        "index_patterns" : [
          ".kibana",
          ".kibana-6",
          ".kibana_*",
          ".opensearch_dashboards",
          ".opensearch_dashboards-6",
          ".opensearch_dashboards_*"
        ],
        "fls" : [ ],
        "masked_fields" : [ ],
        "allowed_actions" : [
          "read",
          "index"
        ]
      },
      {
        "index_patterns" : [
          "auditoria-*"
        ],
        "dls" : "",
        "fls" : [ ],
        "masked_fields" : [ ],
        "allowed_actions" : [
          "read",
          "index"
        ]
      }
    ],
    "tenant_permissions" : [
      {
        "tenant_patterns" : [
          "global_tenant"
        ],
        "allowed_actions" : [
          "kibana_all_read"
        ]
      }
    ]
}

PUT _plugins/_security/api/rolesmapping/arus_cliente
{
  "backend_roles" : [ "aruscliente" ]
}