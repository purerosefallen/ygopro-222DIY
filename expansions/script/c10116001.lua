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
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3331))
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
	--set
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetRange(LOCATION_FZONE)
	e9:SetDescription(aux.Stringid(10116001,1))
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCountLimit(1,10116001)
	e9:SetCondition(c10116001.setcon)
	e9:SetTarget(c10116001.settg)
	e9:SetOperation(c10116001.setop)
	c:RegisterEffect(e9)
end 
function c10116001.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10116001.cfilter,1,nil,tp)
end
function c10116001.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0x3331) and (c:IsLevelAbove(5) or c:IsRankAbove(5)) and c:IsFaceup() and c:GetReasonEffect() and c:GetReasonEffect():GetHandler():IsSetCard(0x3331) and c:GetReasonEffect():GetHandler():IsType(TYPE_MONSTER)
end
function c10116001.setfilter(c)
	return c:IsSetCard(0x3331) and bit.band(c:GetType(),0x10002)==0x10002 and c:IsSSetable()
end
function c10116001.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10116001.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c10116001.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c10116001.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SSet(tp,g:GetFirst())
	   Duel.ConfirmCards(1-tp,g)
	end
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

function c10116001.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3331)
end

function c10116001.chainlm(e,ep,tp)
	return ep==tp
end

function c10116001.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return (te:IsHasCategory(CATEGORY_SPECIAL_SUMMON) or te:IsHasCategory(CATEGORY_SUMMON)) and te:GetHandler():IsSetCard(0x3331)
end
