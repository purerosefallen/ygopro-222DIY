--自由斗士·疾行的红
function c10131002.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true) 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10131002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c10131002.sptg)
	e1:SetOperation(c10131002.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10131002,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetCountLimit(1,10131002)
	e2:SetTarget(c10131002.destg)
	e2:SetOperation(c10131002.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)  
	c:RegisterEffect(e3)   
end
function c10131002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ng=Duel.GetMatchingGroupCount(c10131002.desfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	if chkc then return chkc:IsOnField() end
	if chk==0 then return ng>0 and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ng,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10131002.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
function c10131002.desfilter(c)
	return c:IsSetCard(0x5338) and c:IsFaceup()
end
function c10131002.spfilter(c,e,tp,seq)
	return Card.IsSetCard(0x5338) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetSequence()==seq
end
function c10131002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	if chk==0 then return tc and tc:IsSetCard(0x5338) and tc:IsCanBeEffectTarget(e) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10131002.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end