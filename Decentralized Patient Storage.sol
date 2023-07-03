// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Patient_Storage {
    struct Doctor {
        uint256 id;
        string name;
        string qualification;
        string workplace;
    }
    struct Medicine {
        uint256 id;
        string name;
        string dose;
        string expiryDate;
        uint256 price;
    }
    struct Patient {
        uint256 id;
        string name;
        uint256 age;
        string disease;
    }
    struct Disease {
        uint256 id;
        string disease;
    }
    struct Age {
        uint256 id;
        uint256 age;

    }
    struct Prescription {
        string medicine;
        address patient;
    }
    
  mapping(uint256 => Medicine) public medicines;
    uint256 public medicineCounter;
    mapping(uint256 => Doctor) public doctors;
    uint256 public doctorCounter;
    mapping(uint256 => Patient) public patients;
    uint256 public patientCounter;
    mapping(uint256 => Disease) public diseases;
    uint256 public diseaseCounter;
    mapping(uint256 => Age) public age;
    uint256 public ageCounter;
    mapping(address => Prescription[] ) private prescribedMedicine;

    constructor() {
        doctorCounter = 0;
    medicineCounter = 0;
    patientCounter = 0;
    diseaseCounter=0;
    ageCounter=0;
    }

    function registerDoctor(string memory _name, string memory _qualification, string memory _workplace) public {
        doctorCounter++;
        doctors[doctorCounter] = Doctor(doctorCounter, _name, _qualification, _workplace );
    }

    function viewtDoctorById(uint256 _doctorId) public view returns (uint256, string memory, string memory , string memory) {
        require(doctors[_doctorId].id != 0, "Doctor does not exist");

        return (doctors[_doctorId].id, doctors[_doctorId].name, doctors[_doctorId].qualification , doctors[_doctorId].workplace);
    }
     function addMedicine(string memory _name, string memory _dose, string memory _expiryDate , uint256 _price ) public {
        medicineCounter++;
        medicines[medicineCounter] = Medicine(medicineCounter, _name, _dose , _expiryDate , _price  );
    }

    function viewMedicineById(uint256 _medicineId) public view returns (uint256, string memory, string memory , string memory , uint256) {
        require(medicines[_medicineId].id != 0, "Medicine does not exist");

        return (medicines[_medicineId].id, medicines[_medicineId].name, medicines[_medicineId].dose , medicines[_medicineId].expiryDate , medicines[_medicineId].price);
    }
    function registerPatient(string memory _name, uint256 _age , string memory _disease) public {
        patientCounter++;
        patients[patientCounter]=Patient(patientCounter , _name , _age , _disease);
    }   
    function viewRecord(uint256 _patientId) public view returns ( uint256 , string memory , uint256 , string memory) {
        require(patients[_patientId].id !=0, "Patient does not exist");
        return ( patients[_patientId].id , patients[_patientId].name , patients[_patientId].age , patients[_patientId].disease);
    }
    function addNewDisease(string memory _disease) public {
        diseaseCounter++;
        diseases[diseaseCounter]= Disease(diseaseCounter , _disease);
    }
    function updateAge(uint256 _age) public{
    ageCounter++;   
        age[ageCounter]= Age(ageCounter, _age);
    }
    event MedicinePrescribed( string  _medicine,address indexed patient);

    function prescribeMedicine(address _patientAddress , string memory _medicine ) external {
        require(_patientAddress != address(0), "Invalid patient address.");
        require(bytes(_medicine).length >0,"Medicine name cannot be empty.");

        Prescription memory prescription = Prescription(_medicine , _patientAddress);

        prescribedMedicine[_patientAddress].push(prescription);

        emit MedicinePrescribed(_medicine , _patientAddress);
    }

    function viewPrescribedMedicine(address _patientAddress) external view returns (Prescription[] memory) {
        return prescribedMedicine[_patientAddress];
    }
}