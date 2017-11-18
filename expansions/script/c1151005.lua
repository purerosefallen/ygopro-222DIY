--浓雾的吸血鬼·蕾米莉亚
function c1151005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1151005,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c1151005.tg1)
	e1:SetOperation(c1151005.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1151005,2))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1151006)
	e2:SetTarget(c1151005.tg2)
	e2:SetOperation(c1151005.op2)
	c:RegisterEffect(e2)
--
end
--
c1151005.named_with_Leimi=1
function c1151005.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
function c1151005.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151005.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
--
function c1151005.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1151005,0))
		local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
		local t=0
		local opt=Duel.SelectOption(tp,70,71,72)
		if opt==0 then t=TYPE_MONSTER 
		else
			if opt==1 then 
				t=TYPE_SPELL 
			else t=TYPE_TRAP 
			end
		end
		Duel.ConfirmDecktop(tp,1)
		Duel.ShuffleDeck(tp)
		if tc:IsType(t) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 then
			if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==1 then
				Duel.SortDecktop(tp,1-tp,1)
			else
				Duel.SortDecktop(tp,1-tp,2)
			end
			if e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			end
		else
			if e:GetHandler():IsAbleToHand() then
				Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
			end
		end
	end
end
--
function c1151005.tfilter2(c)
	return c1151005.IsLeisp(c) and c:IsType(TYPE_SPELL)
end
function c1151005.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1151005.tfilter2(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c1151005.tfilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1151005,1))
	local g=Duel.SelectTarget(tp,c1151005.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
end
--
function c1151005.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_GRAVE) then
		local e2_1=Effect.CreateEffect(tc)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_CHANGE_TYPE)
		e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2_1:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_1,true) 
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e2_2=Effect.CreateEffect(tc)
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2_2:SetCode(EFFECT_CHANGE_CODE)
		e2_2:SetRange(LOCATION_SZONE)
		e2_2:SetValue(1151999)
		e2_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_2,true)
		local e2_3=Effect.CreateEffect(tc)
		e2_3:SetType(EFFECT_TYPE_FIELD)
		e2_3:SetCode(EFFECT_SPSUMMON_PROC_G)
		e2_3:SetRange(LOCATION_SZONE)
		e2_3:SetCountLimit(1,1151999)
		e2_3:SetCondition(c1151005.con2_3)
		e2_3:SetOperation(c1151005.op2_3)
		e2_3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_3,true)			
	end
end
--
function c1151005.cfilter2_3(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()<5 and c:IsRace(RACE_FIEND)
end
function c1151005.con2_3(e,c,og)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c1151005.cfilter2_3,tp,LOCATION_HAND,0,1,nil,e,tp) and c:IsFaceup() and not c:IsDisabled() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--
function c1151005.op2_3(e,tp,eg,ep,ev,re,r,rp,c,sg,og)  
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1151005.cfilter2_3,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	sg:Merge(g)
end
--
