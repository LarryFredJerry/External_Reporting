Select 
  '129' as LEA_ID
, schoolid AS LOCAL_SCHOOL_ID 
, '' AS LOCAL_SCHOOL_TYPE
, '2016-2017' AS SCHOOL_YEAR
, ps_customfields.getStudentsCF(s.id, 'SPED_esy') AS ENROLLMENT_PERIOD
, TO_CHAR(SYSDATE,'MM/DD/YYYY HH24:MI')AS COLLECTION_DATE
, 'Enrollment' COLLECTION_TYPE
, student_number AS SIS_ID
, to_char(grade_level) AS ENROLL_GRADE_LEVEL
, case when schoolid = 2001 then ps_customfields.getStudentsCF(s.id,'SPED_Placed_Campus_ID') else TO_CHAR(schoolid) end AS ATTENDING_SCHOOL_ID 
, case when schoolid = 2001 then ps_customfields.getStudentsCF(s.id, 'SPED_NPP_School') else sc.abbreviation end AS ATTENDING_SCHOOL_NAME
, NULL as DUAL_ENROLLMENT
, NULL AS ATTENDING_SCHOOL_TYPE
, '' AS SITE_ID
, '' AS SITE_NAME
, 'PE' as ENROLLMENT_TYPE
, '' AS ENROLLMENT_1_APPLICATION
, '' AS ENROLLMENT_2_NOTIFICATION
, '' AS ENROLLMENT_3_ACCEPTED
, TO_CHAR(entrydate,'MM/DD/YYYY') AS ENROLLMENT_4_REGISTRATION
, case --make date null if current date is before stage 5 enrollment date
  when(
      case 
        when entrydate <= '08-AUG-16' and grade_level between -1 and 8 then to_char('08/08/2016')   
        when entrydate <= '15-AUG-16' and (grade_level = -2 or grade_level = 9) then to_char('08/15/2016')   
        when entrydate <= '22-AUG-16' and grade_level between 10 and 12 then to_char('08/22/2016') 
        else to_char(entrydate,'MM/DD/YYYY') 
      end) >= to_char(sysdate,'MM/DD/YYYY') then NULL 
  else (
      case 
        when entrydate <= '08-AUG-16' and grade_level between -1 and 8 then to_char('08/08/2016')   
        when entrydate <= '15-AUG-16' and (grade_level = -2 or grade_level = 9) then to_char('08/15/2016')   
        when entrydate <= '22-AUG-16' and grade_level between 10 and 12 then to_char('08/22/2016') 
        else to_char(entrydate,'MM/DD/YYYY') 
      end) 
  end AS ENROLLMENT_5_SERVICES_RECEIVED
, case 
    when ((grade_level between -1 and 8 and sysdate < '08-AUG-16' ) or
          (grade_level = -2 and sysdate < '15-AUG-16') or
          (grade_level between 10 and 12 and sysdate < '22-AUG-16')) then NULL --make enrollment_code null if stage 5 date is after current date (sysdate)
  else entrycode end AS ENROLLMENT_CODE
, '' AS EXIT_DATE
, exitcode AS EXIT_CODE
, '' AS ENROLLMENT_TRANS_ID
FROM students s
join schools sc on sc.school_number = s.schoolid
where entrydate >= '01-JUL-16'
