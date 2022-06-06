SELECT M.CHROM AS CHROM, M.POS AS POS, "." AS ID, M.REF AS REF, M.ALT AS ALT, round(snpq,3) AS QUAL, "." AS FILTER, INFO, FORMAT, FORMAT_data
	FROM
	(SELECT count(P.idPatient) AS pcount, M.idMutation AS mut, avg(P.snp_quality) AS snpq, P.INFO AS INFO, P.FORMAT AS FORMAT, P.FORMAT_data AS FORMAT_data
		FROM patientmutations P, mutation M
		WHERE M.idMutation = P.idMutation AND
			(M.region = "exonic" OR
			M.region = "exonic;splicing" OR
			M.region = "splicing") AND
			ISNULL(M.dbSNP135_full) AND
			M.change != "synonymous_SNV"
		GROUP BY M.idMutation) gp, mutation M
	WHERE gp.pcount > 0
		AND M.idMutation = gp.mut
	ORDER BY CHROM ASC;