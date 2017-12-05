create or replace FUNCTION
liczba_miejsc_w_sali (nr_sali IN INTEGER)RETURN NUMBER IS
ile NUMBER;
BEGIN
   --sprawdzenie czy jest sala o takim nr, jesli nie, rzuca wyjatek
  SELECT 0 into ile FROM miejsca where sala_nr_sali = nr_sali;
  SELECT count(*) INTO ile from miejsca WHERE sala_nr_sali = nr_sali;
  return ile;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Brak sali o podanym numerze');
END liczba_miejsc_w_sali;
/
BEGIN
      DBMS_OUTPUT.PUT_LINE(LICZBA_MIEJSC_W_SALI(5));
END;
/



