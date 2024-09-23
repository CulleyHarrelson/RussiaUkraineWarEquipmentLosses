{% macro predict_equipment_category(column_name) %}
    CASE
        /* Combat Aircraft */
        WHEN {{ column_name }} ~* 'F-\d+|MiG|Su-|Rafale|Typhoon|Gripen|J-\d+|Kfir' THEN 'Combat Aircraft'
        WHEN {{ column_name }} ~* 'B-\d+|Tu-\d+|H-6|Vulcan|Backfire' THEN 'Combat Aircraft'
        WHEN {{ column_name }} ~* 'A-\d+|Su-25|Warthog|Frogfoot|fighter\ jet|strike\ aircraft' THEN 'Combat Aircraft'
        WHEN {{ column_name }} ~* 'L-39|Su-\d+|MiG-\d+' THEN 'Combat Aircraft'

        /* UAV/Drone */
        WHEN {{ column_name }} ~* 'UAV|RQ-\d+|MQ-\d+|Predator|Reaper|Global\ Hawk|Bayraktar|Orlan|SKAT|SpecAero|Tekever|ZALA' THEN 'UAV/Drone'
        WHEN {{ column_name }} ~* 'TB2|Orlan-\d+|Mohajer-\d+|Forpost|ScanEagle|ITEC\ Skif|Penguin\ C|Primoco|Punisher|Raybird' THEN 'UAV/Drone'

        /* Support Aircraft */
        WHEN {{ column_name }} ~* 'C-\d+|Il-\d+|An-\d+|KC-\d+|A\d+\d+M|Hercules' THEN 'Support Aircraft'
        WHEN {{ column_name }} ~* 'E-\d+|RC-\d+|U-2|SR-71|AWACS|Hawkeye' THEN 'Support Aircraft'
        WHEN {{ column_name }} ~* 'P-\d+|P-8|Tu-142|Orion|Poseidon' THEN 'Support Aircraft'
        WHEN {{ column_name }} ~* 'EA-\d+|EF-\d+|Growler|Prowler|Orlik' THEN 'Support Aircraft'
        WHEN {{ column_name }} ~* 'KC-135|Il-78|A330 MRTT' THEN 'Support Aircraft'

        /* Helicopter */
        WHEN {{ column_name }} ~* 'AH-\d+|Ka-\d+|Mi-\d+|Apache|Cobra|Hind' THEN 'Helicopter'
        WHEN {{ column_name }} ~* 'UH-\d+|CH-\d+|Mi-8|Chinook|Blackhawk|Helecopter|helicopter' THEN 'Helicopter'

        /* Armored Fighting Vehicle */
        WHEN {{ column_name }} ~* 'T-\d+|Abrams|Leopard|Challenger|Merkava' THEN 'Armored Fighting Vehicle'
        WHEN {{ column_name }} ~* 'BMP|Bradley|Warrior|Puma' THEN 'Armored Fighting Vehicle'
        WHEN {{ column_name }} ~* 'M113|BTR|Stryker|VAB' THEN 'Armored Fighting Vehicle'
        WHEN {{ column_name }} ~* 'T-\d+|Unknown tank' THEN 'Armored Fighting Vehicle'
        WHEN {{ column_name }} ~* 'BMP-\d+|BMD-\d+|BRM-\d+' THEN 'Armored Fighting Vehicle'
        WHEN {{ column_name }} ~* 'MT-LB|BTR-\d+' THEN 'Armored Fighting Vehicle'
        WHEN {{ column_name }} ~* 'AAV-7|BMP-3F|Type 05' THEN 'Armored Fighting Vehicle'

        /* Artillery */
        WHEN {{ column_name }} ~* 'M109|PzH|CAESAR|Archer' THEN 'Artillery'
        WHEN {{ column_name }} ~* 'MLRS|Grad|Smerch|HIMARS' THEN 'Artillery'
        WHEN {{ column_name }} ~* 'M777|2S19|FH70' THEN 'Artillery'
        WHEN {{ column_name }} ~* '2S1|2S3|2S5|2S7|2S9|2S19|2S22|2S23|2S33|2S34' THEN 'Artillery'
        WHEN {{ column_name }} ~* 'D-20|D-30|D-44|2A36|2A65|M777|FH70|TRF1' THEN 'Artillery'
        WHEN {{ column_name }} ~* '2B9|2B11|2B16|2S12|M120K' THEN 'Artillery'
        WHEN {{ column_name }} ~* 'BM-21|BM-27|BM-30|TOS-1A|2B17|RM-70' THEN 'Artillery'
        WHEN {{ column_name }} ~* '155mm|howitzer|2A65 Msta-B|2S1 Gvozdika|2S3 Akatsiya|2S19 Msta-S|M109|M777|FH70|D-20|D-30|2S22 Bohdana|ShKH vz\. 77 DANA|AHS Krab|PzH 2000|G6|CAESAR|Archer' THEN 'Artillery'

        /* Support Vehicle */
        WHEN {{ column_name }} ~* 'Fennek|BRDM|Fuchs|fuel\ tanker' THEN 'Support Vehicle'
        WHEN {{ column_name }} ~* 'GAZ Tigr|International MaxxPro|Mastiff|Wolfhound|Husky|Kozak|Roshel Senator|MaxxPro|Iveco|Panthera|Remdiesel' THEN 'Support Vehicle'
        WHEN {{ column_name }} ~* 'UAZ-469|HMMWV|Oncilla' THEN 'Support Vehicle'
        WHEN {{ column_name }} ~* 'Ural-\d+|KamAZ|GAZ-\d+|KrAZ|truck|ural|Daewoo|MLZh-VF-VT' THEN 'Support Vehicle'
        WHEN {{ column_name }} ~* 'BREM-\d+|IMR-\d+|MTP-\d+' THEN 'Support Vehicle'
        WHEN {{ column_name }} ~* 'recovery\ vehicle|workshop|MTO-|ambulance|bathhouse|YAD\ 4442\ NT' THEN 'Support Vehicle'
        WHEN {{ column_name }} ~* 'R-\d+|1L\d+|9S\d+|forward\ observer\ vehicle|battery\ fire\ control\ center' THEN 'Support Vehicle'
        WHEN {{ column_name }} ~* 'PMP|TMM-\d+' THEN 'Support Vehicle'
        WHEN {{ column_name }} ~* 'Uran-9|THeMIS|MUTT' THEN 'Support Vehicle'

        /* Naval Vessels */
        WHEN {{ column_name }} ~* 'CVN-|Admiral Kuznetsov|Queen Elizabeth' THEN 'Naval Vessel'
        WHEN {{ column_name }} ~* 'DDG-|Type 052|Arleigh Burke' THEN 'Naval Vessel'
        WHEN {{ column_name }} ~* 'SSN-|SSBN-|Akula|Typhoon|Astute' THEN 'Submarine'
        WHEN {{ column_name }} ~* 'FFG-|Type 054|FREMM' THEN 'Naval Vessel'
        WHEN {{ column_name }} ~* 'Corvette|Buyan-M|Visby' THEN 'Naval Vessel'
        WHEN {{ column_name }} ~* 'Patrol Boat|Dvora|CB90' THEN 'Naval Vessel'
        WHEN {{ column_name }} ~* 'LHD-|Mistral|Wasp' THEN 'Naval Vessel'
        WHEN {{ column_name }} ~* 'Project \d+|Class' THEN 'Naval Vessel'
        WHEN {{ column_name }} ~* 'Avenger-class|Tripartite|Katanpää' THEN 'Naval Vessel'
        WHEN {{ column_name }} ~* 'LCAC|LCU|Type 726' THEN 'Naval Vessel'

        /* Weapon Systems */
        WHEN {{ column_name }} ~* 'ZSU-23|Gepard|Tunguska' THEN 'Air Defense System'
        WHEN {{ column_name }} ~* 'S-300|S-400|Patriot|THAAD|NASAMS' THEN 'Air Defense System'
        WHEN {{ column_name }} ~* 'Pantsir|Tor|Buk' THEN 'Air Defense System'
        WHEN {{ column_name }} ~* 'Javelin|Kornet|NLAW|TOW' THEN 'Anti-Tank System'
        WHEN {{ column_name }} ~* '9K\d+|9M\d+|Metis|Konkurs' THEN 'Anti-Tank System'
        WHEN {{ column_name }} ~* 'Tomahawk|Kalibr|Kh-101' THEN 'Missile'
        WHEN {{ column_name }} ~* 'Iskander|Scud|Hwasong' THEN 'Missile'

        /* Electronic Warfare and Command Systems */
        WHEN {{ column_name }} ~* 'Krasukha|Murmansk-BN|EA-18G|EW\ system' THEN 'Electronic Warfare and Command System'
        WHEN {{ column_name }} ~* 'AN/SPY-1|AESA|Nebo|radar|Palantin' THEN 'Electronic Warfare and Command System'
        WHEN {{ column_name }} ~* 'AWACS|E-3|A-50|Yastreb' THEN 'Electronic Warfare and Command System'


        WHEN {{ column_name }} ~* 'van|vehicle|LuAZ|UAZ-' THEN 'Unknown Vehicle'

        ELSE 'Unknown'
    END
{% endmacro %}
