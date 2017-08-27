--夜鸦·TGR-Ⅲ
function c10114009.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10114009,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10114009)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c10114009.spcon)
	e1:SetCost(c10114009.spcost)
	e1:SetTarget(c10114009.sptg)
	e1:SetOperation(c10114009.spop)
	c:RegisterEffect(e1) 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10114009.incon)
	e2:SetTarget(c10114009.reptg)
	e2:SetValue(c10114009.repval)
	--c:RegisterEffect(e2)
	--local g=Group.CreateGroup()
	--g:KeepAlive()
	--e2:SetLabelObject(g)  
	--indes normal ver
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c10114009.reptg2)
	e4:SetValue(c10114009.indct)
	c:RegisterEffect(e4)
	--fuck then condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c10114009.spop2)
	c:RegisterEffect(e3)	
end

function c10114009.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and re:GetHandler():IsSetCard(0x3331) then
	   c:RegisterFlagEffect(10114009,RESET_EVENT+0x1ff0000,0,1)
	end
	c:RegisterFlagEffect(10114109,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c10114009.reptg2(e,c)
	return c:IsSetCard(0x3331) and c:IsFaceup()
end
function c10114009.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c10114009.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetFlagEffect(10114209)==0 and c:IsSetCard(0x3331)
end
function c10114009.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10114009.repfilter,1,nil,tp) end
	local g=eg:Filter(c10114009.repfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(10114209,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10114009,1))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function c10114009.repval(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end
function c10114009.incon(e)
	return e:GetHandler():GetFlagEffect(10114009)>0
end
function c10114009.spcon(e)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():GetFlagEffect(10114109)==0 
end
function c10114009.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10114009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c10114009.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and c:IsAbleToDeckAsCost()
	end
	if c:GetFlagEffect(10114009)>0 then e:SetLabel(1) end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c10114009.filter(c,e,tp)
	local rc=e:GetHandler()
	return (c:IsLevelBelow(6) or ((e:GetLabel()==1 or rc:GetFlagEffect(10114009)>0) and c:GetLevel()==7)) and c:IsSetCard(0x3331) and not c:IsCode(10114009) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10114009.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10114009.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end