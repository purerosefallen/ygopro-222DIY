--升阶魔法-幻葬之歌
function c66678922.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66678922+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c66678922.target)
	e1:SetOperation(c66678922.activate)
	c:RegisterEffect(e1)
end
function c66678922.filter1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c66678922.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c) and c:IsControlerCanBeChanged()
end
function c66678922.filter2(c,e,tp,mc)
	if c:GetOriginalCode()==6165656 and not mc:IsCode(48995978) then return false end
	local rk=0
	if mc:IsType(TYPE_XYZ) then
		rk=mc:GetRank()
	else
		rk=mc:GetLevel()
	end
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x665) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true) and c:GetRank()>rk
end
function c66678922.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c66678922.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c66678922.filter1,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c66678922.filter1,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(aux.FALSE)
end
function c66678922.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ck=Duel.GetControl(tc,tp)
		if not ck and not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
		if ck and not tc:IsImmuneToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c66678922.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
			local sc=g:GetFirst()
			if sc then
				local mg=tc:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				sc:SetMaterial(Group.FromCards(tc))
				Duel.Overlay(sc,Group.FromCards(tc))
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
				sc:CompleteProcedure()
				e:GetHandler():CancelToGrave()
				Duel.Overlay(sc,Group.FromCards(e:GetHandler()))
			end
		end
	end
end