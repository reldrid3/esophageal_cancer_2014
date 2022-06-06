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
	T.OMIM,
	T.CHROM,
	T.POS,
	T.ID,
	T.REF,
	T.ALT
FROM tempdata T;

INSERT INTO patientmutations
SELECT
	T.idPatient,
	CONCAT(T.chr_name,T.chr_start,T.chr_end,T.ref_base,T.alt_base),
	T.snp_quality,
	T.tot_depth,
	T.alt_depth,
	T.FILTER,
	T.INFO,
	T.FORMAT,
	T.FORMAT_data
FROM tempdata T;