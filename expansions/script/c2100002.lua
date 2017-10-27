--风蚀的银屑 哈露西
function c2100002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c2100002.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2100002,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,2100002)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c2100002.destg)
	e1:SetOperation(c2100002.desop)
	c:RegisterEffect(e1)
end
function c2100002.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3219) and c:IsType(TYPE_MONSTER)
end
function c2100002.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0 and
		Duel.IsExistingMatchingCard(c2100002.filter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c2100002.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3219) and c:IsPosition(POS_FACEUP_ATTACK) 
end
function c2100002.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c2100002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c2100002.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2100002.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c2100002.filter2,tp,0,LOCATION_ONFIELD,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACK)
	local g=Duel.SelectTarget(tp,c2100002.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c2100002.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsPosition(POS_FACEUP_ATTACK) then
		if Duel.ChangePosition(c,POS_FACEUP_DEFENSE)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,c2100002.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end