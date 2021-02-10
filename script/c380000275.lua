--Dark Horizon
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
	aux.GlobalCheck(s,function()
		s[0]=0
		s[1]=0
		s[2]=0
		s[3]=0
		s[4]=0
		s[5]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			local p=Duel.GetTurnPlayer()
			s[2+(1-p)]=0
			s[4+p]=s[2+p]
			s[2+p]=0
			s[p]=0
		end)
	end)
end
s.listed_names={CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL}
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=Duel.GetTurnPlayer() then
		s[ep]=s[ep]+ev
	end
	if ep==Duel.GetTurnPlayer() then
		s[2+ep]=s[2+ep]+ev
	end
end
function s.filter(c,chk)
	return c:IsCode(CARD_DARK_MAGICIAN_GIRL) or (chk and c:IsCode(CARD_DARK_MAGICIAN))
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	local dm=(s[tp]>=2500 or s[4+tp]>=2500)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,CARD_DARK_MAGICIAN)
	return aux.CanActivateSkill(tp) and (s[tp]>=2000 or s[4+tp]>=2000)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,dm)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--play 1 dm or dmg
	local dm=(s[tp]>=2500 or s[4+tp]>=2500)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,CARD_DARK_MAGICIAN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,dm)
	local tc=g:GetFirst()
	if tc then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		tc:RegisterEffect(e0)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
		e0:Reset()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
