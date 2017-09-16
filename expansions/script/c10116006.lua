--真夜鸦大回旋
function c10116006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,0x1e0)
	e1:SetCountLimit(1,10116006+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10116006.target)
	e1:SetOperation(c10116006.activate)
	c:RegisterEffect(e1) 
end
function c10116006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10116006.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c10116006.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanSpecialSummonMonster(tp,10114013,0x3331,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK) and Duel.GetFlagEffect(tp,10116006)<=0 end
	local ct=Duel.GetMatchingGroupCount(c10116006.filter,tp,LOCATION_MZONE,0,nil)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10116006.filter,tp,LOCATION_MZONE,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,g:GetCount(),0,0)
end
function c10116006.filter(c)
	return c:IsSetCard(0x3331) and c:IsAbleToRemove()
end
function c10116006.activate(e,tp,eg,ep,ev,re,r,rp)
	local c,g=e:GetHandler(),Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<=0 then return end
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct<=0 then return end
	local rg=Duel.GetOperatedGroup()
	rg:KeepAlive()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,10114013,0x3331,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK) then
	   if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	   for i=1,ct do
		   local token=Duel.CreateToken(tp,10114013)
		   Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		   e1:SetValue(1)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   token:RegisterEffect(e1,true)
	   end
	   Duel.SpecialSummonComplete()
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
	   local tc,fid=rg:GetFirst(),c:GetFieldID()
	   while tc do
			 tc:RegisterFlagEffect(10116006,RESET_EVENT+0x1fe0000,0,0,fid)
	   tc=rg:GetNext()
	   end
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e2:SetCode(EVENT_PHASE+PHASE_END)
	   e2:SetReset(RESET_PHASE+PHASE_END)
	   e2:SetCountLimit(1)
	   e2:SetOperation(c10116006.endop)
	   Duel.RegisterEffect(e2,tp)
	   e2:SetLabelObject(rg)
	   e2:SetLabel(fid)
	end
end
function c10116006.endop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10116006)
	local g,mg=Duel.GetMatchingGroup(c10116006.desfilter,tp,LOCATION_MZONE,0,nil),e:GetLabelObject()
	Duel.Destroy(g,REASON_EFFECT)
	local tg,ft,sg=mg:Filter(c10116006.spfilter,nil,e,tp),Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or tg:GetCount()<=0 then	
	   mg:DeleteGroup()
	   e:Reset()
	return 
	end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>=tg:GetCount() then
	   sg=tg:Clone()
	else
	   local ct=math.min(tg:GetCount(),ft)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   sg=tg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c10116006.desfilter(c)
	return c:IsCode(10114013) and c:IsFaceup()
end
function c10116006.spfilter(c,e,tp)
	return c:GetFlagEffectLabel(10116006)==e:GetLabel() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end