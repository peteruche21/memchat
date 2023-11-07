export async function handle(state, action) {
    const input = action.input;
  
    const evm_molecule_endpoint = state.evm_molecule_endpoint;
  
    if (input.function === "sign") {
      const {caller, message, signature} = input;
  
      ContractAssert(caller && message && signature, "missing required arguments");
      ContractAssert(!state.signed.includes(signature), "signature used");
  
      await _verifySignature(caller, message, signature);
  
      state.signed.push(signature);
  
      return { state };
    }
  
    async function _verifySignature(caller, message, signature) {
      try {
      const isValid = await EXM.deterministicFetch(
          `${evm_molecule_endpoint}/signer/${caller}/${message}/${signature}`
      );
      ContractAssert(isValid.asJSON()?.result, "unauthorized caller");
      } catch (error) {
      throw new ContractError("molecule res error");
      }
    }
  }