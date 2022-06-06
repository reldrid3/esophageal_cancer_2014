COMMIT;
REPLACE INTO mutation
SELECT DISTINCT
	CONCAT(T.chr_name,T.chr_start,T.chr_end,T.ref_base,T.alt_base),
	T.chr_name,
	T.chr_start,
	T.chr_end,
	T.ref_base,
	T.alt_base,
	T.hom_het,
	T.region,
	T.gene,
	T.change,
	T.annotation,
	T.dbSNP135_full,
	T.dbSNP135_common,
	T.1000G_2010Nov_allele_freq,
	T.1000G_2011Oct_allele_freq,
	T.SCS,
	T.CLN,
	T.OMIM
FROM tempdata T;
COMMIT;

INSERT INTO patientmutations
SELECT
	T.idPatient,
	CONCAT(T.chr_name,T.chr_start,T.chr_end,T.ref_base,T.alt_base),
	T.snp_quality,
	T.tot_depth,
	T.alt_depth
FROM tempdata T;
COMMIT;