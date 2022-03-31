--Deck Master Effect: Strike Ninja
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={41006930}
s.listed_series={0x2b,0x61}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_SZONE,nil)>0
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil))
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_ONFIELD,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	--condition
	return aux.CanActivateSkill(tp) and (b1 or b2)
	and Duel.GetLP(tp)<=1500
end
function s.filter(c)
	return c:IsFacedown() and not c:IsType(TYPE_FIELD)
end
function s.tgfilter(c)
	return c:IsSetCard(0x2b) or c:IsSetCard(0x61)
end
function s.filter2(c,tp)
	return c:GetOwner()==1-tp
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_SZONE,nil)>0
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil))
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_ONFIELD,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	local g=nil
	local sg=nil
	if opt==0 then
		Duel.RegisterFlagEffect(ep,id,0,0,0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			Duel.SendtoGrave(tc,REASON_RULE)
			if tc:IsLocation(LOCATION_REMOVED) then
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		local sg=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_SZONE,1,1,nil)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	else
		Duel.RegisterFlagEffect(ep,id+1,0,0,0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_REMOVED)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			Duel.Remove(tc,POS_FACEUP,REASON_RULE)
		end
		local token=Duel.CreateToken(tp,41006930)
		if token then
			--Move to field
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_FREE_CHAIN)
			e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
			token:RegisterEffect(e0)
			Duel.MoveToField(token,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
			e0:Reset()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_PHASE+PHASE_END)
			token:RegisterEffect(e1)
		end
	end
end
