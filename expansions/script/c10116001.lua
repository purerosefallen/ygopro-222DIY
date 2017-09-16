--夜鸦·寂静城
function c10116001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(c10116001.efilter)
	c:RegisterEffect(e2)	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetValue(c10116001.efilter)
	c:RegisterEffect(e5)
	--cannot disable summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c10116001.sumfilter)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)   
	c:RegisterEffect(e4)
	--act limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(c10116001.sumscon)
	e6:SetOperation(c10116001.sumsuc)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCode(EVENT_CHAIN_END)
	e8:SetOperation(c10116001.sumsuc2)
	c:RegisterEffect(e8)
	--activate or set
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(10116001,0))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCountLimit(1)
	e9:SetHintTiming(0,0x1e0)
	e9:SetCondition(c10116001.accon)
	e9:SetTarget(c10116001.actg)
	e9:SetOperation(c10116001.acop)
	c:RegisterEffect(e9) 
	if not c10116001.global_check then
		c10116001.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c10116001.spcheckop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c10116001.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10116001)>0
end
function c10116001.spcheckop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c10116001.checkfilter,1,nil) then
	   Duel.RegisterFlagEffect(eg:GetFirst():GetSummonPlayer(),10116001,RESET_PHASE+PHASE_END,0,1)
	end
end
function c10116001.checkfilter(c)
	local lv=c:GetOriginalLevel()
	if c:IsType(TYPE_XYZ) then
	   lv=c:GetOriginalRank()
	end
	return c:IsSetCard(0x3331) and c:IsSetCard(0x3331) and lv>=5 and c:IsFaceup()
end
function c10116001.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10116001.acfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c10116001.acfilter(c,tp)
	return c:IsSetCard(0x3331) and bit.band(c:GetType(),0x10002)==0x10002 and (c:GetActivateEffect():IsActivatable(tp) or c:IsSSetable())
end
function c10116001.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10116001,2))
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10116001.acfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	local b1=tc:IsSSetable()
	local b2=tc:GetActivateEffect():IsActivatable(tp)
	if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(10116001,3))) then
	   Duel.SSet(tp,tc)
	   Duel.ConfirmCards(1-tp,tc)
	else
	   Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
	   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   local te=tc:GetActivateEffect()
	   local tep=tc:GetControler()
	   local cost=te:GetCost()
	   local target=te:GetTarget()
	   local operation=te:GetOperation()
	   tc:CancelToGrave(false)
	   tc:CreateEffectRelation(te)
	   if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	   if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
	   local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	   if g and g:GetCount()>0 then
		  local tg=g:GetFirst()
		  while tg do
				tg:CreateEffectRelation(te)
		  tg=g:GetNext()
		  end
	   end
	   tc:SetStatus(STATUS_ACTIVATED,true)
	   if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
	   tc:ReleaseEffectRelation(te)
	   if g and g:GetCount()>0 then
		  tg=g:GetFirst()
		  while tg do
				tg:ReleaseEffectRelation(te)
		  tg=g:GetNext()
		  end
	   end
	   Duel.RegisterFlagEffect(tp,tc:GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
	   Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c10116001.sumfilter(e,c)
	return c:IsSetCard(0x3331) and c:GetSummonPlayer()==e:GetHandlerPlayer()
end
function c10116001.sumsuc2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(10116001)~=0 then
		Duel.SetChainLimitTillChainEnd(c10116001.chainlm)
	end
	e:GetHandler():ResetFlagEffect(10116001)
end
function c10116001.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if  Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c10116001.chainlm)
	else
		e:GetHandler():RegisterFlagEffect(10116001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c10116001.sumscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10116001.sfilter,1,nil,tp)
end
function c10116001.sfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3331) and c:GetSummonPlayer()==tp
end
function c10116001.chainlm(e,ep,tp)
	return ep==tp
end
function c10116001.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and te:GetHandler():IsSetCard(0x3331) and p==tp
end