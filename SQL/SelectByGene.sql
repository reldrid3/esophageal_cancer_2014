SELECT *
	FROM
	(SELECT gp6.gene AS gene
		FROM
		(SELECT DISTINCT gp.gene, count(gp.idPatient) AS pcount
			FROM
			(SELECT DISTINCT M.gene, P.idPatient
				FROM patientmutations P, mutation M
				WHERE
					M.idMutation = P.idMutation AND
					P.snp_quality > 20 AND
					M.region != "intronic" AND
					(	(ISNULL(M.1000G_2010Nov_allele_freq) AND
							ISNULL(M.1000G_2011Oct_allele_freq)) OR
						(M.1000G_2010Nov_allele_freq < 0.05 OR
							M.1000G_2011Oct_allele_freq < 0.05))) gp
		GROUP BY gp.gene) gp6
	WHERE
		gp6.pcount > 5
	ORDER BY pcount DESC) M2
	NATURAL JOIN
	(SELECT
		M.gene AS gene,
		M.dbSNP135_full,
		M.chr_name,
		M.chr_start,
		M.chr_end,
		M.ref_base,
		M.alt_base,
		M.1000G_2010Nov_allele_freq,
		M.1000G_2011Oct_allele_freq
		FROM mutation M
		WHERE
			(M.chr_start - M.chr_end = 0) AND
			M.ref_base != "-" AND
			M.alt_base != "-" AND
			((ISNULL(M.1000G_2010Nov_allele_freq) AND
				ISNULL(M.1000G_2011Oct_allele_freq)) OR
				(M.1000G_2010Nov_allele_freq < 0.05 OR
				M.1000G_2011Oct_allele_freq < 0.05))) M3;