import { useContract, useContractRead, useAddress } from "@thirdweb-dev/react";
import {  NFT_STAKING_ADDRESS } from "../const/contractAddresses";
import { Button } from '@chakra-ui/react';

export default function Defensive() {
  const stakingContractAddress = NFT_STAKING_ADDRESS;
  const { contract } = useContract(stakingContractAddress);
  const address = useAddress();
  const { data, isLoading } = useContractRead(contract, "getStakedDefensiveNames", address);

  return (
    <div style={{ margin: "30px"}}>
      {isLoading ? (
        <p>Loading...</p>
      ) : (
        <ul>
          {data && data.map((defensive, index) => (
            <Button colorScheme='blue' key={index}>{defensive}</Button>
          ))}
        </ul>
      )}
    </div>
  );
}
