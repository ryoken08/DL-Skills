--Forbidden Contract
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={73360025,10833828}
s.filter=aux.FilterFaceupFunction(Card.IsCode,73360025)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetLP(tp)<=2000
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_SZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Select 1 face-up "Dark Contract with the Swamp King" on your field
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_SZONE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		--Change it to "Forbidden Dark Contract with the Swamp King"
		g:GetFirst():Recreate(10833828,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
end
