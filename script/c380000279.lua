--Spiral Spear Strike
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={CARD_GAIA_CHAMPION,49328340}
s.listed_series={0xbd}
function s.filter(c)
	return c:IsFaceup() and ((c:IsSetCard(0xbd) and c:IsAttackAbove(2300)) or c:IsCode(CARD_GAIA_CHAMPION))
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil) 
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local token=Duel.CreateToken(tp,49328340)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
