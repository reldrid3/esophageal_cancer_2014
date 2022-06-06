SELECT M.CHROM AS CHROM, M.POS AS POS, "." AS ID, M.REF AS REF, M.ALT AS ALT, snpq AS QUAL, "." AS FILTER, INFO
	FROM
	(SELECT count(P.idPatient) AS pcount, M.idMutation AS mut, avg(P.snp_quality) AS snpq, P.INFO AS INFO
		FROM patientmutations P, mutation M
		WHERE M.idMutation = P.idMutation AND
			P.snp_quality > 20 AND
			M.region = "exonic" AND
			(M.chr_start - M.chr_end = 0) AND
			M.ref_base != "-" AND
			M.alt_base != "-" AND
			(	(ISNULL(M.1000G_2010Nov_allele_freq) AND
					ISNULL(M.1000G_2011Oct_allele_freq)) OR
				(M.1000G_2010Nov_allele_freq < 0.05 OR
					M.1000G_2011Oct_allele_freq < 0.05))
		GROUP BY M.idMutation) gp, mutation M
	WHERE gp.pcount > 5
		AND M.idMutation = gp.mut
	ORDER BY CHROM ASC;