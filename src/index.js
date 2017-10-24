const wasm = require("./main.rs")
wasm.initialize({ noExitRuntime: true }).then(module => {
  // Wrap exported functions
  const cwrappings = {
    regex_compare:  ['regex_compare',  'bool', ['string', 'string']],
    free_c_string:  ['free_c_string',  null, ['number']],
    to_string:      ['to_string',      'string', ['number']],
    validate_regex: ['validate_regex', 'string', ['string']],
  }

  var lib = {}

  for (var fn in cwrappings) {
    lib[fn] = module.cwrap(...cwrappings[fn])
  }

  // Safely wrap regex validation
  const validate_regex = function(string) {
    const response = lib.validate_regex(string)
    if (response === "") {
      return null
    } else {
      return response
    }
  }

  // Use exported functions
  const updateResult = function() {
    const reg = document.getElementById('reg').value || ''
    const target = document.getElementById('target').value || ''
    var result = document.getElementById('result')
    const regex_err = validate_regex(reg)
    result.innerHTML = regex_err ? `
    <span style='font-family: monospace; color: salmon'>${regex_err}</span>
    ` : `
    <span style='font-family: monospace'>/${reg}/</span> ${
      lib.regex_compare(reg, target) ? 'matches' : 'does not match'
    } <span style='font-family: monospace'>"${target}"</span>
    `
  }

  document.getElementById('reg').onkeyup = updateResult
  document.getElementById('target').onkeyup = updateResult
  updateResult()

  window.stupid_to_string = lib.to_string
})
