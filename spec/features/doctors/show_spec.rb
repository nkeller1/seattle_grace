require 'rails_helper'

RSpec.describe "Doctor Show Page" do
    it "can see the doctors information" do

    hospital_1 = Hospital.create(
      name: "Grey Sloan Memorial Hospital"
      )

    doctor_1 = Doctor.create!(
        name: "Meredith Grey",
        specialty: "General Surgery",
        university: "Harvard",
        hospital: hospital_1
      )

    doctor_2 = Doctor.create!(
        name: "Alex Karev",
        specialty: "Pediatric Surgery",
        university: "Johns Hopkins University",
        hospital: hospital_1
      )

    patient_1 = Patient.create!(
        name: "Katie Bryce",
        age: 24,
      )

    patient_2 = Patient.create!(
        name: "Denny Smith",
        age: 39,
      )

    doctor_1.patients << [patient_1, patient_2]

    visit "/doctors/#{doctor_1.id}"

    expect(page).to have_content(doctor_1.name)
    expect(page).to have_content(doctor_1.university)
    expect(page).to have_content(doctor_1.specialty)
    expect(page).to have_content(hospital_1.name)
    expect(page).to have_content(patient_1.name)
    expect(page).to have_content(patient_2.name)
    expect(page).not_to have_content(doctor_2.name)
  end

  it "shows a button to remove a patient" do
    hospital_1 = Hospital.create(
      name: "Grey Sloan Memorial Hospital"
      )

    doctor_1 = Doctor.create!(
        name: "Meredith Grey",
        specialty: "General Surgery",
        university: "Harvard",
        hospital: hospital_1
      )

    patient_1 = Patient.create!(
        name: "Katie Bryce",
        age: 24,
      )

    patient_2 = Patient.create!(
        name: "Denny Smith",
        age: 39,
      )

    doctor_1.patients << [patient_1, patient_2]

    visit "/doctors/#{doctor_1.id}"

    within "#patient-#{patient_2.id}" do
      click_on ("Remove Patient")
    end

    expect(current_path).to eq("/doctors/#{doctor_1.id}")
    expect(page).not_to have_content(patient_2.name)
    expect(page).not_to have_content(patient_2.age)

    expect(page).to have_content(patient_1.name)

    visit "/patients"

    expect(page).to have_content(patient_2.name)
  end

  it "shows a button to remove a when patient has multiple doctors" do
    hospital_1 = Hospital.create(
      name: "Grey Sloan Memorial Hospital"
      )

    doctor_1 = Doctor.create!(
        name: "Meredith Grey",
        specialty: "General Surgery",
        university: "Harvard",
        hospital: hospital_1
      )

    doctor_2 = Doctor.create!(
        name: "Other Doctor",
        specialty: "General Surgery",
        university: "Place",
        hospital: hospital_1
      )

    patient_1 = Patient.create!(
        name: "Katie Bryce",
        age: 24,
      )

    patient_2 = Patient.create!(
        name: "Denny Smith",
        age: 39,
      )

    doctor_1.patients << [patient_1, patient_2]
    doctor_2.patients << [patient_1, patient_2]

    visit "/doctors/#{doctor_1.id}"

    within "#patient-#{patient_2.id}" do
      click_on ("Remove Patient")
    end

    expect(current_path).to eq("/doctors/#{doctor_1.id}")
    expect(page).not_to have_content(patient_2.name)
    expect(page).not_to have_content(patient_2.age)

    expect(page).to have_content(patient_1.name)

    visit "/patients"

    expect(page).to have_content(patient_2.name)
  end
end
