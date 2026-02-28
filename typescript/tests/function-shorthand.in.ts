const scalarEditor = createDomEditor({
        container: document.querySelector("#editor-scalar"),
        value: scalarInitial,
        schema: scalarSchema,
        lenient: false,
        onChange(next) {
          outputScalar.textContent = JSON.stringify(next, null, 2)
          window.localStorage.setItem("json-editor-demo-scalar", JSON.stringify(next))
        },
        classes,
        defaultCollapsed: false
      })
