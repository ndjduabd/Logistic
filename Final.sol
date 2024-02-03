// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract LogisticContract {
    address public owner;
    uint256 private counter;

    struct Shipment {
        uint256 id;
        string productName;
        string senderAddress;
        string recipientAddress;
        uint256 sendingDate;
        uint256 deliveryDate;
        string cargoCompanyInformation;
        uint256 trackingNumber;
        bool delivered;
    }

    mapping(uint256 => Shipment) public shipments;

    event ShipmentCreated(uint256 id, string productName, string senderAddress, string recipientAddress, uint256 sendingDate, string cargoCompanyInformation, uint256 trackingNumber);
    event ShipmentDelivered(uint256 id, uint256 deliveryDate);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this");
        _;
    }

    function createShipment(string memory _productName, string memory _senderAddress, string memory _recipientAddress, uint256 _sendingDate, string memory _cargoCompanyInformation, uint256 _trackingNumber) external onlyOwner {
        counter++;
        shipments[counter] = Shipment(counter, _productName, _senderAddress, _recipientAddress, _sendingDate, 0, _cargoCompanyInformation, _trackingNumber, false);

        emit ShipmentCreated(counter, _productName, _senderAddress, _recipientAddress, _sendingDate, _cargoCompanyInformation, _trackingNumber);
    }

    function updateDeliveryDate(uint256 _shipmentId, uint256 _deliveryDate) external onlyOwner {
        require(_shipmentId <= counter, "Invalid shipment ID");
        require(shipments[_shipmentId].delivered == false, "Shipment already delivered");

        shipments[_shipmentId].deliveryDate = _deliveryDate;
        shipments[_shipmentId].delivered = true;

        emit ShipmentDelivered(_shipmentId, _deliveryDate);
    }

    function getShipmentDetails(uint256 _shipmentId) external view returns (Shipment memory) {
        require(_shipmentId <= counter, "Invalid shipment ID");
        return shipments[_shipmentId];
    }
}
