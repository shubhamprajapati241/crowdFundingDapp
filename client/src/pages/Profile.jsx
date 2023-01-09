import React, { useState, useEffect } from "react";
import { useStateContext } from "../context";
import { DisplayCampaigns } from "../components";

const Profile = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [campaigns, setCampaigns] = useState([]);

  const { address, contract, getUserCampaign } = useStateContext();

  const fetchCampaigns = async () => {
    setIsLoading(true);
    const data = await getUserCampaign();
    setCampaigns(data);
    setIsLoading(false);
  };
  useEffect(() => {
    if (contract) fetchCampaigns();

    // 2.18.45 => home, detials , loader
  }, [address, contract]);
  return (
    <DisplayCampaigns
      title="My Campaign"
      isLoading={isLoading}
      campaigns={campaigns}
    />
  );
};

export default Profile;
