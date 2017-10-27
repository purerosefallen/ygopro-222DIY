--巨大战舰 三角三（D）
function c13257210.initial_effect(c)
	c:EnableCounterPermit(0x1f)
	--summon with no tribute
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(13257210,1))
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SUMMON_PROC)
	e11:SetCondition(c13257210.ntcon)
	e11:SetOperation(c13257210.ntop)
	c:RegisterEffect(e11)
	--Destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c13257210.desreptg)
	e1:SetOperation(c13257210.desrepop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c13257210.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257210,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c13257210.spcon)
	e4:SetTarget(c13257210.sptg)
	e4:SetOperation(c13257210.spop)
	c:RegisterEffect(e4)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetOperation(c13257210.bgmop)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
	
end
function c13257210.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetMZoneCount(c:GetControler())>0
end
function c13257210.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1200)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetValue(4)
	c:RegisterEffect(e2)
end
function c13257210.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
		and e:GetHandler():GetCounter(0x1f)>0 end
	return true
end
function c13257210.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1f,1,REASON_EFFECT)
end
function c13257210.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1f,3)
end
function c13257210.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler()
end
function c13257210.spfilter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsSetCard(0x353) and not c:IsCode(13257210)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13257210.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c13257210.spfilter(chkc,e,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c13257210.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c13257210.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c13257210.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257210,4))
end
