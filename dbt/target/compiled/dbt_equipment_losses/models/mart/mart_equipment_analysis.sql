

SELECT
    country,
    origin,
    system,
    status,
    url,
    date_recorded,
    "sysID" as sysid,
    "imageID" as imageid,
    "statusID" as statusid,
    "matID" as matid,
    
    CASE
        /* Aircraft */
        WHEN system ~* 'F-\d+|MiG|Su-|Rafale|Typhoon|Gripen|J-\d+|Kfir' THEN 'Fighter Jet'
        WHEN system ~* 'B-\d+|Tu-\d+|H-6|Vulcan|Backfire' THEN 'Bomber'
        WHEN system ~* 'C-\d+|Il-\d+|An-\d+|KC-\d+|A\d+\d+M|Hercules' THEN 'Transport Plane'
        WHEN system ~* 'E-\d+|RC-\d+|U-2|SR-71|AWACS|Hawkeye' THEN 'Reconnaissance Aircraft'
        WHEN system ~* 'AH-\d+|Ka-\d+|Mi-\d+|Apache|Cobra|Hind' THEN 'Attack Helicopter'
        WHEN system ~* 'UH-\d+|CH-\d+|Mi-8|Chinook|Blackhawk' THEN 'Transport Helicopter'
        WHEN system ~* 'UAV|RQ-\d+|MQ-\d+|Predator|Reaper|Global Hawk|Bayraktar|Orlan' THEN 'UAV/Drone'
        WHEN system ~* 'A-\d+|Su-25|Warthog|Frogfoot' THEN 'Ground Attack Aircraft'
        WHEN system ~* 'P-\d+|P-8|Tu-142|Orion|Poseidon' THEN 'Maritime Patrol Aircraft'
        WHEN system ~* 'EA-\d+|EF-\d+|Growler|Prowler' THEN 'Electronic Warfare Aircraft'

        /* Ground Vehicles */
        WHEN system ~* 'T-\d+|Abrams|Leopard|Challenger|Merkava' THEN 'Main Battle Tank'
        WHEN system ~* 'BMP|Bradley|Warrior|Puma' THEN 'Infantry Fighting Vehicle'
        WHEN system ~* 'M113|BTR|Stryker|VAB' THEN 'Armored Personnel Carrier'
        WHEN system ~* 'M109|PzH|CAESAR|Archer' THEN 'Self-Propelled Artillery'
        WHEN system ~* 'MLRS|Grad|Smerch|HIMARS' THEN 'Multiple Rocket Launcher'
        WHEN system ~* 'Fennek|BRDM|Fuchs' THEN 'Armored Reconnaissance Vehicle'

        /* Naval Vessels */
        WHEN system ~* 'CVN-|Admiral Kuznetsov|Queen Elizabeth' THEN 'Aircraft Carrier'
        WHEN system ~* 'SSN-|SSBN-|Akula|Typhoon|Astute' THEN 'Submarine'
        WHEN system ~* 'DDG-|Type 052|Arleigh Burke' THEN 'Destroyer'
        WHEN system ~* 'FFG-|Type 054|FREMM' THEN 'Frigate'
        WHEN system ~* 'Corvette|Buyan-M|Visby' THEN 'Corvette'
        WHEN system ~* 'Patrol Boat|Dvora|CB90' THEN 'Patrol Boat'
        WHEN system ~* 'LHD-|Mistral|Wasp' THEN 'Amphibious Assault Ship'

        /* Weapon Systems */
        WHEN system ~* 'M777|2S19|FH70' THEN 'Artillery Piece'
        WHEN system ~* 'ZSU-23|Gepard|Tunguska' THEN 'Anti-Aircraft Gun'
        WHEN system ~* 'S-300|S-400|Patriot|THAAD' THEN 'Surface-to-Air Missile System'
        WHEN system ~* 'Javelin|Kornet|NLAW|TOW' THEN 'Anti-Tank Guided Missile'
        WHEN system ~* 'Tomahawk|Kalibr|Kh-101' THEN 'Cruise Missile'
        WHEN system ~* 'Iskander|Scud|Hwasong' THEN 'Ballistic Missile'

        /* Electronic Warfare Equipment */
        WHEN system ~* 'Krasukha|Murmansk-BN|EA-18G' THEN 'Electronic Warfare System'
        WHEN system ~* 'AN/SPY-1|AESA|Nebo' THEN 'Radar System'

        /* Command and Control Systems */
        WHEN system ~* 'AWACS|E-3|A-50' THEN 'Airborne Early Warning and Control'
        WHEN system ~* 'KC-135|Il-78|A330 MRTT' THEN 'Air-to-Air Refueling Tanker'

        /* Unmanned Ground Vehicles */
        WHEN system ~* 'Uran-9|THeMIS|MUTT' THEN 'Unmanned Ground Vehicle'

        /* Naval Mines and Mine Countermeasures */
        WHEN system ~* 'Avenger-class|Tripartite|Katanpää' THEN 'Minesweeper Vessel'

        /* Amphibious Vehicles */
        WHEN system ~* 'AAV-7|BMP-3F|Type 05' THEN 'Amphibious Assault Vehicle'
        WHEN system ~* 'LCAC|LCU|Type 726' THEN 'Landing Craft'

        ELSE 'Other Military Equipment'
    END
 AS predicted_category
FROM "dbt_equipment_losses"."public"."equipment_losses"