--虚太古龙·炽烈神
function c10163004.initial_effect(c)
	c:SetSPSummonOnce(10163004)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c10163004.spcon)
	e2:SetOperation(c10163004.spop)
	c:RegisterEffect(e2)  
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10163004,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetCountLimit(1,10163004)
	e3:SetCost(c10163004.rmcost)
	e3:SetTarget(c10163004.rmtg)
	e3:SetOperation(c10163004.rmop)
	c:RegisterEffect(e3)  
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c10163004.antarget)
	c:RegisterEffect(e8)
end
function c10163004.antarget(e,c)
	return c~=e:GetHandler()
end
function c10163004.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10163004.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10163004.spfilter2,tp,0x13,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10163004.rmop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10163004.spfilter2,tp,0x13,0,1,1,nil,e,tp):GetFirst()
	if tc and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		   local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		   if rg:GetCount()>0 then
			  Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		   end
	end
end
function c10163004.spfilter2(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c)
end
function c10163004.spfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x11,0,0,0,0,0) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c)
end
function c10163004.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10163004.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10163004.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10163004.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_RACE)
		e2:SetValue(RACE_ALL)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e3:SetValue(0xff)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		tc:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(9)
		tc:RegisterEffect(e6,true)
	 end
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)~=0 then
		   Duel.ConfirmCards(1-tp,tc)
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		   local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		   if rg:GetCount()>0 then
			  Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		   end
		end
end
function c10163004.rfilter(c,tp,ct,ec)
	return (c:IsLevelAbove(8) or c:IsAttribute(ATTRIBUTE_FIRE)) and ((ct==1 and Duel.CheckReleaseGroupEx(tp,c10163004.rfilter,1,c,tp,0)) or ct==0) and c~=ec
end
function c10163004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then return Duel.CheckReleaseGroupEx(tp,c10163004.rfilter,2,c,tp,0,c)
	else return Duel.CheckReleaseGroup(tp,c10163004.rfilter2,1,c,tp,1,c)
	end
	return false
end
function c10163004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g1=Duel.SelectReleaseGroupEx(tp,c10163004.rfilter,2,2,c,tp,0,c)
	   Duel.Release(g1,REASON_COST)
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g1=Duel.SelectReleaseGroup(tp,c10163004.rfilter,1,1,c,tp,1,c)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g2=Duel.SelectReleaseGroupEx(tp,c10163004.rfilter,1,1,g1:GetFirst(),tp,0,c)
	   g1:Merge(g2)
	   Duel.Release(g1,REASON_COST)
	end
end