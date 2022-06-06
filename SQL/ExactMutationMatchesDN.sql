SELECT gp.pcount, M.chr_name, M.gene, M.chr_start, M.chr_end, M.ref_base, M.alt_base, M.dbsnp135_full, M.region
	FROM
	(SELECT count(P.idPatient) AS pcount, M.idMutation AS mut
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
		GROUP BY M.idMutation) gp, Mutation M
	WHERE gp.pcount > 5
		AND M.idMutation = gp.mut
	ORDER BY gp.pcount DESC;