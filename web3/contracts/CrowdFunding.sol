// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0; // for the compains which we will create

    function createCompaign(address _owner, string memory _title, string memory _desciption, uint256 _target, uint256 _deadline, string memory _image) public returns(uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(campaign.deadline < block.timestamp , "The deadline should be a date in the future"); // checking the deadline date.

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _desciption;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns -1 ;
    }

    function donateToCompain(uint256 _id) public payable {
        uint256 amount = msg.value;
        Campaign storage campaign = campaigns[_id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value : amount}("");

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }

    }

    function getDonators(uint256 _id) view public returns(address[] memory, uint256[] memory) {
        return(campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCompains() view public returns(Campaign[] memory){
        Campaign[] memory allCompains = new Campaign[](numberOfCampaigns); // creating the empty address for storing the campaigns

        for(uint i=0; i< numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];
            allCompains[i] = item;  // iterating and pushing the contains into the empty campains array
        }

        return allCompains;
    }


}