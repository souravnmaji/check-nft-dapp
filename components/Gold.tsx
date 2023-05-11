import { Web3Button } from "@thirdweb-dev/react";

export default function Gold() {
  //const args = [];  no arguments to pass to the contract function

  return (
    <Web3Button
    contractAddress="0x96B4a42D34Cb673eb78a76c33A485747D8072b07"
      action={(contract) => {
        contract.call("buyGoldPackage", { value: "2000000000000000" }); // 0.2 BNB
      }}
    >
      Become Gold Member
    </Web3Button>
  );
}
