local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("img", {
    t("#figure("), t({ "", "  " }),
    t("image(\""), i(1, "image_path"), t("\", width: 70%),"), t({ "", "  " }),
    t("kind: \"image\","), t({ "", "  " }),
    t("supplement: \"Image\","), t({ "", "  " }),
    t("caption: ["), t({ "", "    " }),
    i(2, "image_caption"), t({ "", "  " }),
    t("],"), t({ "", "" }),
    t(") <"), i(3, "image_id"), t({ ">", "" }),
  }),

  s("code", {
    t("#figure(```"), i(1, "code_language"), t({ "", "  " }),
    i(2, "code_code"), t({ "", "  " }),
    t("```, kind: \"code\","), t({ "", "  " }),
    t("supplement: \"Code\","), t({ "", "  " }),
    t("caption: ["), t({ "", "    " }),
    i(3, "code_caption"), t({ "", "  " }),
    t("],"), t({ "", "" }),
    t(") <"), i(4, "code_id"), t({ ">", "" }),
  }),

  s("table", {
    t("#figure("), t({ "", "  " }),
    t("caption: ["), t({ "", "    " }),
    i(1, "table_caption"), t({ "", "  " }),
    t("],"), t({ "", "  " }),
    t("kind: \"table\","), t({ "", "  " }),
    t("supplement: \"Table\","), t({ "", "  " }),
    t("table(columns: "), i(2, "num_of_columns"), t({ ",", "  " }),
    t("["), i(3, "table_content"), t("],"), t({ "", "  " }),
    t(")"), t({ "", "" }),
    t(") <"), i(4, "table_id"), t({ ">", "" }),
  }),
}
