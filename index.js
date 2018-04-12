import { CompiledRegex } from './rust_wasm'
import { booted } from './rust_wasm_bg'

booted.then(() => {
    var raw_reg = null

    // Will be caching the compiled regular expression between
    // changes. Needs to respond to the `free` function.
    var compiled_reg = {
      free: function() {},
    }

    const result = (function() {
      const ok                = document.getElementById('result-ok')
      const ok_regex          = document.getElementById('result-ok-regex')
      const ok_matches        = document.getElementById('result-ok-matches')
      const ok_does_not_match = document.getElementById('result-ok-does-not-match')
      const ok_target         = document.getElementById('result-ok-target')
      const err               = document.getElementById('result-err')

      return {
        ok: function(reg, is_match, target) {
          ok_regex.innerText = `/${reg}/`

          const matches = is_match ? [ok_matches, ok_does_not_match] : [ok_does_not_match, ok_matches]
          matches[1].setAttribute('hidden', '')
          matches[0].removeAttribute('hidden')

          ok_target.innerText = `"${target}"`

          err.setAttribute('hidden', '')
          ok.removeAttribute('hidden')
        },
        err: function(err_message) {
          err.innerText = err_message

          err.removeAttribute('hidden')
          ok.setAttribute('hidden', '')
        },
      }
    })()

    const reg_elmt = document.getElementById('reg')
    const target_elmt = document.getElementById('target')

    const updateResult = function() {
      const reg = reg_elmt.value || ''
      const target = target_elmt.value || ''

      if (raw_reg !== reg) {
        compiled_reg.free()
        compiled_reg = CompiledRegex.new(reg)
        raw_reg = reg
      }

      if (compiled_reg.is_valid()) {
        result.ok(reg, compiled_reg.is_match(target), target)
      } else {
        result.err(compiled_reg.error_message())
      }
    }

    reg_elmt.onkeyup = updateResult
    target_elmt.onkeyup = updateResult
    updateResult()
  })
