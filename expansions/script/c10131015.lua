--自由-强袭
function c10131015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10131015+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c10131015.target)
	e1:SetOperation(c10131015.activate)
	c:RegisterEffect(e1)	
end
function c10131015.filter(c,e,tp,rc)
	return c:IsFaceup() and c:IsSetCard(0x5338) and Duel.IsExistingMatchingCard(c10131015.filter2,tp,LOCATION_ONFIELD,0,1,c,e,rc)
end
function c10131015.filter2(c,e,rc)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and c~=rc
end
function c10131015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10131015.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10131015.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),e,tp,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c10131015.filter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g2=Duel.SelectTarget(tp,c10131015.filter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),e)
	local g3=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c10131015.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local sg=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil)
	sg:Merge(tg)
	if sg:GetCount()>0 then
	   Duel.Destroy(sg,REASON_EFFECT)
	end
end