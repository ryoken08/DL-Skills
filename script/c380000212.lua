--Fleeting Hand
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={99177923,56209279,66957584}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
	local b2=(Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,2,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local b3=(Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,3,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
	--condition
	return aux.CanActivateSkill(tp) and (b1 or b2 or b3)
	and (Duel.GetLP(1-tp)-Duel.GetLP(tp))>=2000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
	local b2=(Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,2,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local b3=(Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,3,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=3
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,sel,sel,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
	end
	if sel==1 then
		local token=Duel.CreateToken(tp,99177923)
		Duel.SendtoDeck(token,nil,SEQ_DECKTOP,REASON_RULE)
	elseif sel==2 then
		local token=Duel.CreateToken(tp,56209279)
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
	else
		local token=Duel.CreateToken(tp,66957584)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
