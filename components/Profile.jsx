import { ChainId, useAddress, ConnectWallet } from "@thirdweb-dev/react";
import { useEffect, useState } from "react";
import NftCardContainer from "./NftCardContainer";
import styles from "../styles/css.module.css";
import { Card,CardBody } from '@chakra-ui/react'

export default function Profile() {
  // Wallet connection hooks from React SDK
  const address = useAddress();

  // State to store the user's loaded tokens
  const [isLoading, setIsLoading] = useState(true);
  const [tokenData, setTokenData] = useState([]);
  const [chainId, setChainId] = useState(1);

  // Make a request to the get-wallet-data api endpoint (/api/get-wallet-data.js file)
  useEffect(() => {
    if (address) {
      // If there is a connected address, make the request.
      (async () => {
        try {
          setTokenData([]);
          setIsLoading(true);

          const req = await fetch("/api/get-wallet-data", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },

            body: JSON.stringify({
              address: address,
              chainId: chainId,
            }),
          });

          // De-structure tokens out of the response JSON
          const { tokens } = await req.json();

          // Set the tokens in state.
          setTokenData(tokens.filter((t) => t.type === "nft"));
        } catch (error) {
          console.error("Error getting tokens", error);
        } finally {
          setIsLoading(false);
        }
      })();
    }
  }, [address, chainId]);

  return (
    <div>
      <>
      <Card style={{margin: "30px"}}>
        <CardBody>
        <div style={{padding: "50px"}}>
          {address ? (
            <div>
              <h1 style={{fontFamily: "fantasy", fontSize: "30px"}}>Check Your&apos;s NFTs Collection</h1>

              <p style={{fontFamily: "sans-serif"}}>Select any supported chain below:</p>

              <div>
                {/* Dropdown  Menu of Chain IDs */}
                <select
                  style={{padding: "10px", width: "-webkit-fill-available"}}
                  onChange={(e) => setChainId(e.target.value)}
                  value={chainId}
                >
                  {Object.entries(ChainId)
                    .filter(([key]) => isNaN(Number(key)))
                    .filter(
                      ([key]) =>
                        key !== "Localhost" &&
                        key !== "Hardhat" &&
                        key !== "Rinkeby"
                    )
                    .map(([key, value], index) => (
                      <option
                        key={index}
                        value={value}
                        onSelect={(e) => setChainId(e.target.value)}
                      >
                        {key}
                      </option>
                    ))}
                </select>
              </div>

            

              {!isLoading ? (
                <div style={{ display: "flex", flexDirection: "column" }}>
                  {tokenData
                    ?.filter((t) => t.type === "nft")
                    ?.filter((t) => t.supports_erc?.includes("erc721"))
                    ?.map((nftCollection, i) => (
                      <NftCardContainer
                        nftCollection={nftCollection}
                        chainId={chainId}
                        key={i}
                      />
                    ))}
                </div>
              ) : (
                <p>Loading...</p>
              )}
            </div>
          ) : (
            <ConnectWallet colorMode="dark" accentColor="#5204BF" />
          )}
        </div>
        </CardBody>
        </Card>
      </>
    </div>
  );
}
