{% macro predict_equipment_category(column_name) %}
    CASE
        /* Aircraft */
        WHEN {{ column_name }} ~* 'F-\d+|MiG|Su-|Rafale|Typhoon|Gripen|J-\d+|Kfir' THEN 'Fighter Jet'
        WHEN {{ column_name }} ~* 'B-\d+|Tu-\d+|H-6|Vulcan|Backfire' THEN 'Bomber'
        WHEN {{ column_name }} ~* 'C-\d+|Il-\d+|An-\d+|KC-\d+|A\d+\d+M|Hercules' THEN 'Transport Plane'
        WHEN {{ column_name }} ~* 'E-\d+|RC-\d+|U-2|SR-71|AWACS|Hawkeye' THEN 'Reconnaissance Aircraft'
        WHEN {{ column_name }} ~* 'AH-\d+|Ka-\d+|Mi-\d+|Apache|Cobra|Hind' THEN 'Attack Helicopter'
        WHEN {{ column_name }} ~* 'UH-\d+|CH-\d+|Mi-8|Chinook|Blackhawk' THEN 'Transport Helicopter'
        WHEN {{ column_name }} ~* 'UAV|RQ-\d+|MQ-\d+|Predator|Reaper|Global Hawk|Bayraktar|Orlan' THEN 'UAV/Drone'
        WHEN {{ column_name }} ~* 'A-\d+|Su-25|Warthog|Frogfoot' THEN 'Ground Attack Aircraft'
        WHEN {{ column_name }} ~* 'P-\d+|P-8|Tu-142|Orion|Poseidon' THEN 'Maritime Patrol Aircraft'
        WHEN {{ column_name }} ~* 'EA-\d+|EF-\d+|Growler|Prowler' THEN 'Electronic Warfare Aircraft'

        /* Ground Vehicles */
        WHEN {{ column_name }} ~* 'T-\d+|Abrams|Leopard|Challenger|Merkava' THEN 'Main Battle Tank'
        WHEN {{ column_name }} ~* 'BMP|Bradley|Warrior|Puma' THEN 'Infantry Fighting Vehicle'
        WHEN {{ column_name }} ~* 'M113|BTR|Stryker|VAB' THEN 'Armored Personnel Carrier'
        WHEN {{ column_name }} ~* 'M109|PzH|CAESAR|Archer' THEN 'Self-Propelled Artillery'
        WHEN {{ column_name }} ~* 'MLRS|Grad|Smerch|HIMARS' THEN 'Multiple Rocket Launcher'
        WHEN {{ column_name }} ~* 'Fennek|BRDM|Fuchs' THEN 'Armored Reconnaissance Vehicle'

        /* Naval Vessels */
        WHEN {{ column_name }} ~* 'CVN-|Admiral Kuznetsov|Queen Elizabeth' THEN 'Aircraft Carrier'
        WHEN {{ column_name }} ~* 'SSN-|SSBN-|Akula|Typhoon|Astute' THEN 'Submarine'
        WHEN {{ column_name }} ~* 'DDG-|Type 052|Arleigh Burke' THEN 'Destroyer'
        WHEN {{ column_name }} ~* 'FFG-|Type 054|FREMM' THEN 'Frigate'
        WHEN {{ column_name }} ~* 'Corvette|Buyan-M|Visby' THEN 'Corvette'
        WHEN {{ column_name }} ~* 'Patrol Boat|Dvora|CB90' THEN 'Patrol Boat'
        WHEN {{ column_name }} ~* 'LHD-|Mistral|Wasp' THEN 'Amphibious Assault Ship'

        /* Weapon Systems */
        WHEN {{ column_name }} ~* 'M777|2S19|FH70' THEN 'Artillery Piece'
        WHEN {{ column_name }} ~* 'ZSU-23|Gepard|Tunguska' THEN 'Anti-Aircraft Gun'
        WHEN {{ column_name }} ~* 'S-300|S-400|Patriot|THAAD' THEN 'Surface-to-Air Missile System'
        WHEN {{ column_name }} ~* 'Javelin|Kornet|NLAW|TOW' THEN 'Anti-Tank Guided Missile'
        WHEN {{ column_name }} ~* 'Tomahawk|Kalibr|Kh-101' THEN 'Cruise Missile'
        WHEN {{ column_name }} ~* 'Iskander|Scud|Hwasong' THEN 'Ballistic Missile'

        /* Electronic Warfare Equipment */
        WHEN {{ column_name }} ~* 'Krasukha|Murmansk-BN|EA-18G' THEN 'Electronic Warfare System'
        WHEN {{ column_name }} ~* 'AN/SPY-1|AESA|Nebo' THEN 'Radar System'

        /* Command and Control Systems */
        WHEN {{ column_name }} ~* 'AWACS|E-3|A-50' THEN 'Airborne Early Warning and Control'
        WHEN {{ column_name }} ~* 'KC-135|Il-78|A330 MRTT' THEN 'Air-to-Air Refueling Tanker'

        /* Unmanned Ground Vehicles */
        WHEN {{ column_name }} ~* 'Uran-9|THeMIS|MUTT' THEN 'Unmanned Ground Vehicle'

        /* Naval Mines and Mine Countermeasures */
        WHEN {{ column_name }} ~* 'Avenger-class|Tripartite|Katanpää' THEN 'Minesweeper Vessel'

        /* Amphibious Vehicles */
        WHEN {{ column_name }} ~* 'AAV-7|BMP-3F|Type 05' THEN 'Amphibious Assault Vehicle'
        WHEN {{ column_name }} ~* 'LCAC|LCU|Type 726' THEN 'Landing Craft'

        ELSE 'Other Military Equipment'
    END
{% endmacro %}
