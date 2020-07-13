
pragma solidity >=0.4.25 <0.6.0;

contract DigitalLocker
{
    enum StateType { Requested, DocumentReview, AvailableToShare, SharingRequestPending, SharingWithRequestor, Terminated }
    address public Owner;
    address public BankAgent;
    string public LockerFriendlyName;
    string public LockerIdentifier;
    address public CurrentAuthorizedUser;
    string public ExpirationDate;
    string public Image;
    address public Requestor;
    string public IntendedPurpose;
    string public LockerStatus;
    string public RejectionReason;
    StateType public State;
    constructor(string memory lockerFriendlyName, address bankAgent) public
    {
        Owner = msg.sender;
        LockerFriendlyName = lockerFriendlyName;

        State = StateType.DocumentReview; //////////////// should be StateType.Requested?

        BankAgent = bankAgent;
    }

    
    function UploadDocuments(string memory lockerIdentifier, string memory image) public
    {
        if (Owner != msg.sender)
        {
            revert();
        }
        LockerStatus = "Approved";
        Image = image;
        LockerIdentifier = lockerIdentifier;
        State = StateType.AvailableToShare;
    }

    function ShareWithRequestor(address requestor, string memory expirationDate, string memory intendedPurpose) public
    {
        if (Owner != msg.sender)
        {
            revert();
        }

        Requestor = requestor;
        CurrentAuthorizedUser = Requestor;

        LockerStatus = "Shared";
        IntendedPurpose = intendedPurpose;
        ExpirationDate = expirationDate;
        State = StateType.SharingWithRequestor;
    }

    function AcceptSharingRequest() public
    {
        if (Owner != msg.sender)
        {
            revert();
        }

        CurrentAuthorizedUser = Requestor;
        State = StateType.SharingWithRequestor;
    }

    function RejectSharingRequest() public
    {
        if (Owner != msg.sender)
        {
            revert();
        }
        LockerStatus = "Available";
        CurrentAuthorizedUser = 0x0000000000000000000000000000000000000000;
        State = StateType.AvailableToShare;
    }

    function Rejection(string memory rejectionReason) public
    {
        if (Owner != msg.sender)
        {
            revert();
        }
        RejectionReason=rejectionReason;
       
    }

    function ReleaseLockerAccess() public
    {

        if (CurrentAuthorizedUser != msg.sender)
        {
            revert();
        }
        LockerStatus = "Available";
        Requestor = 0x0000000000000000000000000000000000000000;
        CurrentAuthorizedUser = 0x0000000000000000000000000000000000000000;
        IntendedPurpose = "";
        State = StateType.AvailableToShare;
    }
    
    function RevokeAccessFromThirdParty() public
    {
        if (Owner != msg.sender)
        {
            revert();
        }
        LockerStatus = "Available";
        CurrentAuthorizedUser = 0x0000000000000000000000000000000000000000;
        State = StateType.AvailableToShare;
    }

    function Terminate() public
    {
        if (Owner != msg.sender)
        {
            revert();
        }
        CurrentAuthorizedUser = 0x0000000000000000000000000000000000000000;
        State = StateType.Terminated;
    }
}
