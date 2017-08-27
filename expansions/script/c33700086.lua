--动物朋友 团三郎狸
function c33700086.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	 --copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14017402,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(c33700086.con)
	e1:SetOperation(c33700086.op)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetCondition(c33700086.adcon)
	e2:SetValue(3200)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	e3:SetValue(3200)
	c:RegisterEffect(e3)
end
function c33700086.con(e)
	 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),0,LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetCode)<g:GetCount()
end
function c33700086.filter(c)
	return  c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER)
  and c:IsType(TYPE_EFFECT)
end
function c33700086.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33700086.filter,tp,LOCATION_GRAVE,0,nil)
	local tc=g:GetFirst() 
	while tc do
	   if tc:GetFlagEffect(33700086)==0 then
	   local code=tc:GetOriginalCode()
		local reset_flag=RESET_EVENT+0x1fe0000+RESET_CHAIN+RESET_PHASE
		e:GetHandler():CopyEffect(code,reset_flag,1)
		tc:RegisterFlagEffect(33700086,RESET_EVENT+RESET_CHAIN+RESET_PHASE,0,1)
end
   tc=g:GetNext()
end
end
function c33700086.cfilter(c)
	return  c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER)
end
function c33700086.adcon(e)
	 return not Duel.IsExistingMatchingCard(c33700086.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
