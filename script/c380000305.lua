--Full Armored Xyz [Black Ray]
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={25853045,74416224,5014629}
function s.filter(c,tp)
	return c:IsFaceup() and c:IsCode(74416224,5014629) and c:IsCanBeXyzMaterial(c,tp)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,tp)
	and Duel.IsPlayerCanSpecialSummonMonster(tp,25853045,0,0x800021,2100,600,4,RACE_BEASTWARRIOR,ATTRIBUTE_WATER,POS_FACEUP,tp,SUMMON_TYPE_XYZ)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
		local token=Duel.CreateToken(tp,25853045)
		local mg=tc:GetOverlayGroup()
		if #mg~=0 then
			Duel.Overlay(token,mg)
		end
		token:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(token,Group.FromCards(tc))
		Duel.SpecialSummon(token,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		token:CompleteProcedure()
	end
end
