--ZEXAL - Leo Arms
local ZEXAL=380000353
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.checkcon,s.checkop)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={60992364}
s.listed_series={0x107e}
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 or Duel.GetFlagEffect(ep,ZEXAL)>0 then return end
	--condition
	return Duel.GetCurrentChain()==0
	and Duel.GetTurnPlayer()==tp
	and Duel.GetLP(tp)<=2000
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--ZeXal register
	Duel.RegisterFlagEffect(ep,ZEXAL,0,0,0)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
s.filter=aux.FilterFaceupFunction(Card.IsCode,60992364)
function s.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x107e)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil))
	--ZeXal check
	if Duel.GetFlagEffect(ep,ZEXAL)==0 then return end
	--condition
	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil))
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	local c=e:GetHandler()
	if opt==0 then
		Duel.RegisterFlagEffect(ep,id,0,0,0)
		--play 1 ZW - Leo Arms with 0 ATK/DEF
		local token=Duel.CreateToken(tp,60992364)
		if token then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_FREE_CHAIN)
			e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
			token:RegisterEffect(e0)
			Duel.MoveToField(token,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
			e0:Reset()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_PHASE+PHASE_END)
			token:RegisterEffect(e1)
			--ATK/DEF becomes 0
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_ATTACK)
			e2:SetValue(0)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_SET_DEFENSE)
			token:RegisterEffect(e3)
			--Cannot be tributed
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(3303)
			e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_UNRELEASABLE_SUM)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e4,true)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			token:RegisterEffect(e5,true)
			local e6=Effect.CreateEffect(c)
			e6:SetDescription(3311)
			e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e6,true)
		end
	else
		Duel.RegisterFlagEffect(ep,id+1,0,0,0)
		--Select up to 3 ZW - monsters in your Graveyard
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,3,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=sg:GetFirst()
		if #g>0 then
			Duel.Overlay(tc,g)
		end
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local tdg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil)
			if #tdg>0 then
				Duel.SendtoDeck(tdg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
			end
		end
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
