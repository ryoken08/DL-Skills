--Blaze Accelerator Deployment
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_names={69537999,21420702}
s.filter=aux.FilterFaceupFunction(Card.IsCode,69537999)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_SZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
		local seq=tc:GetSequence()
		tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
		Duel.SendtoDeck(tc,nil,-2,REASON_RULE)
		local token=Duel.CreateToken(tp,21420702)   
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true,(1<<seq))
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
end
