--Dueltaining Stage Change
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_series={0x98,0x9f,0x99}
function s.pendfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x9f) or c:IsSetCard(0x98) or c:IsSetCard(0x99))
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp) and Duel.GetLP(tp)<=2000
	and Duel.IsExistingMatchingCard(s.pendfilter,tp,LOCATION_PZONE,0,2,nil)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		and (c:IsOriginalSetCard(0x98) or c:IsOriginalSetCard(0x9f) or c:IsOriginalSetCard(0x99))
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--select 1 card in your Pendulum Zone and place it face-up on your Extra Deck
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=Duel.SelectMatchingCard(tp,s.pendfilter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoExtraP(g,tp,REASON_RULE)
	--place 1 "Performapal," "Magician," or "Odd-Eyes" Pendulum Monster in your Monster Zone to your Pendulum Zone
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	if #sg>0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	  and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tpg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
		if #tpg>0 then 
			Duel.MoveToField(tpg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
