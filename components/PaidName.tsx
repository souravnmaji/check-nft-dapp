import { useContract, useContractRead, useAddress } from "@thirdweb-dev/react";
import {  NFT_STAKING_ADDRESS } from "../const/contractAddresses";
import { Button } from '@chakra-ui/react';

export default function PaidName() {
  const stakingContractAddress = NFT_STAKING_ADDRESS;
  const { contract } = useContract(stakingContractAddress);
  const address = useAddress();
  const { data, isLoading } = useContractRead(contract, "getStakerPaidName", address);

  return (
    <div style={{ margin: "30px"}}>
    {isLoading ? (
      <p>Loading...</p>
    ) : (
      <ul>
        {Array.isArray(data) ? (
          data.map((say, index) => (
            <Button colorScheme='blue' key={index}>{say}</Button>
          ))
        ) : (
          <Button colorScheme='blue'>{data}</Button>
        )}
      </ul>
    )}
  </div>
);
}
