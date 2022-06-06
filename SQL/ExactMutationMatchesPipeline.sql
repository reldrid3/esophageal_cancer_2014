SELECT gp.pcount, M.chr_name, M.gene, M.chr_start, M.chr_end, M.ref_base, M.alt_base, M.dbSNP135_full, M.region
	FROM
	(SELECT count(P.idPatient) AS pcount, M.idMutation AS mut
		FROM patientmutations P, mutation M
		WHERE M.idMutation = P.idMutation AND
			(M.region = "exonic" OR
			M.region = "exonic;splicing" OR
			M.region = "splicing") AND
			ISNULL(M.dbSNP135_full) AND
			M.change != "synonymous_SNV"
		GROUP BY M.idMutation) gp, Mutation M
	WHERE gp.pcount > 0
		AND M.idMutation = gp.mut
	ORDER BY gp.pcount DESC;